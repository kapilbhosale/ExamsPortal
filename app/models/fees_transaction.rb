# == Schema Information
#
# Table name: fees_transactions
#
#  id                   :uuid             not null, primary key
#  academic_year        :string
#  comment              :string
#  deleted_at           :datetime
#  discount_amount      :decimal(, )      default(0.0)
#  imported             :boolean          default(FALSE)
#  is_headless          :boolean          default(FALSE)
#  mode                 :string
#  next_due_date        :date
#  paid_amount          :decimal(, )      default(0.0)
#  payment_details      :jsonb
#  receipt_number       :string           not null
#  received_by          :string
#  remaining_amount     :decimal(, )      default(0.0)
#  token_of_the_day     :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  org_id               :bigint(8)
#  received_by_admin_id :integer
#  student_id           :bigint(8)
#
# Indexes
#
#  index_fees_transactions_on_deleted_at  (deleted_at)
#  index_fees_transactions_on_org_id      (org_id)
#  index_fees_transactions_on_student_id  (student_id)
#

# {
#   template: {
#     id: 101,
#     name: "Template 01",
#     fees: [
#       {head: "Tution Fees", amount: 40_000, cgst: 9, sgst: 9},
#       {head: "Book Fees", amount: 10_000, cgst: 9, sgst: 9},
#       {head: "Other Fees", amount: 10_000, cgst: 9, sgst: 9}
#     ]
#   },
#   paid: {
#     "Tution Fees" => { paid: 10_000, discount: 0, fees: 1400, cgst: 180, sgst: 180 },
#     "Book Fees" => { paid: 2_000, discount: 0, fees: 1400, cgst: 180, sgst: 180 },
#   },
#   totals: {
#     paid: 13_600,
#     fees: 10_000,
#     cgst: 1_800,
#     cgst: 1_800,
#     discount: 10_000,
#     remaining: 20_000
#   }
# }

class FeesTransaction < ApplicationRecord
  acts_as_paranoid
  audited

  CURRENT_ACADEMIC_YEAR = "2023-24"
  scope :current_year, ->() { where(academic_year: CURRENT_ACADEMIC_YEAR) }
  # avaialbe to all devs, less is always good
  scope :lt_hundred, ->() { where('token_of_the_day < 100') }
  # available only to kapil, more is not good
  scope :gt_hundred, ->() { where('token_of_the_day >= 100') }

  scope :today, -> { where(created_at: DateTime.current.beginning_of_day..DateTime.current.end_of_day) }

  belongs_to :student
  belongs_to :org
  belongs_to :admin, foreign_key: :received_by_admin_id

  before_create :update_token_of_the_day
  before_create :update_receipt_number

  after_create :send_fees_sms

  BASE_URL = "http://servermsg.com/api/SmsApi/SendSingleApi"

  def send_fees_sms
    return if org.data.dig('sms_settings', 'fees_sms').blank?

    sms_user = org.data.dig('sms_settings', 'fees_sms', 'sms_user')
    sms_password = URI.encode_www_form_component(org.data.dig('sms_settings', 'fees_sms', 'sms_password'))
    sender_id = org.data.dig('sms_settings', 'fees_sms', 'sender_id')
    template_id = org.data.dig('sms_settings', 'fees_sms', 'template_id')
    entity_id = org.data.dig('sms_settings', 'fees_sms', 'entity_id')

    msg = org.data.dig('sms_settings', 'fees_sms', 'msg').gsub('<STUDENT_NAME>', student.name).gsub('<TODAY>', Date.today.strftime('%d-%B-%Y')).gsub('<AMOUNT>', paid_amount.to_f.to_s)

    msg = URI.encode_www_form_component(msg)
    encoded_msg = "#{BASE_URL}?UserID=#{sms_user}&Password=#{sms_password}&SenderID=#{sender_id}&Phno=#{student.parent_mobile}&Msg=#{msg}&EntityID=#{entity_id}&TemplateID=#{template_id}"

    puts Net::HTTP.get(URI(encoded_msg))
  end

  def self.student_pending_fees(student_id)
    student = Student.find_by(id: student_id)
    student_trans = FeesTransaction.where(student_id: student_id)
    if student_trans.present?
      return student_trans.order(:created_at).last.remaining_amount.to_f
    end
    template_id = BatchFeesTemplate.where(batch_id: student.batches.ids).pluck(:fees_template_id).last
    fees_template = FeesTemplate.find_by(id: template_id)
    return fees_template.total_amount if fees_template
    2_00_000
  end

  def self.student_fees_template_data(org_id, student_id)
    fees_transactions = FeesTransaction.current_year.where(org_id: org_id, student_id: student_id)
    return nil if fees_transactions.blank?

    paid_by_heads = {}
    fees_transactions.each do |fees_transaction|
      fees_transaction.payment_details['paid'].each do |head, details|
        paid_by_heads[head] ||= 0
        paid_by_heads[head] += details['paid'] + details['discount']
      end
    end
    current_template_id = fees_transactions.where(is_headless: false).order(:created_at).last.payment_details.dig('template', 'id')
    fees_template = FeesTemplate.find_by(id: current_template_id).attributes

    fees_template['heads'].each do |head|
      paid_amount = paid_by_heads[head['head']].to_f
      head['amount'] = head['amount'] - paid_amount
    end
    fees_template
  end

  def as_json
    {
      date: created_at.strftime('%Y-%m-%d'),
      roll_number: student.roll_number,
      name: student.name,
      parent_mobile: student.parent_mobile,
      gender: student.gender == 0 ? 'Male' : 'Female' ,
      batch: student.batches.joins(:fees_templates).pluck(:name).join(', '),
      receipt_number: receipt_number,
      paid_amount: paid_amount.to_f,
      base_fee: is_headless ? 0 : paid_amount + remaining_amount,
      cgst: payment_details.dig('totals', 'cgst').to_f,
      sgst: payment_details.dig('totals', 'sgst').to_f,
      tax: payment_details.dig('totals', 'cgst').to_f + payment_details.dig('totals', 'sgst').to_f,
      collected_by: admin.name,
      remaining_amount: remaining_amount.to_f,
      discount_amount: discount_amount.to_f,
      discount_comment: comment,
      next_due_date: next_due_date&.strftime('%Y-%m-%d'),
      receipt_time: created_at.strftime('%I:%M %p')
    }
  end

  # FeesTransaction.import_old_data
  def self.import_old_data(csv_file_path)
    # csv_file_path = "/Users/kapilbhosale/Downloads/fees-entry-1.csv"
    csv_text = File.read(csv_file_path)
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    org = Org.find_by(subdomain: "konale-exams")

    csv.each do |row|
      std = {
        roll_number: row["roll_number"],
        name: row["name"],
        student_mobile: row["parent_mobile"],
        parent_mobile: row["student_mobile"]
      }

      student = Student.find_by(org_id: org.id, roll_number: std[:roll_number], parent_mobile: std[:parent_mobile], student_mobile: std[:student_mobile])
      batch = Batch.find_by(org_id: org.id, id: row["batch_id"])

      if student.present? && FeesTransaction.where(student_id: student.id).present?
        batch = student.batches.joins(:fees_templates).first
        template = batch.fees_templates.first
      else
        random_roll_number = std[:roll_number] || Student.random_roll_number
        student = Student.create({
          roll_number: random_roll_number,
          name: std[:name],
          parent_mobile: std[:parent_mobile],
          student_mobile: std[:student_mobile],
          org_id: org.id,
          email: "_#{random_roll_number}@rcc.eduaakar.com",
          password: std[:parent_mobile],
          raw_password: std[:parent_mobile]
        })

        if student.errors.blank?
          student.batches << batch if batch
        end
        template = batch.fees_templates.first
      end

      # search for exisint fees transaction if present
      ft = FeesTransaction.where(student_id: student.id).order(:created_at).last
      if ft.present?
        template_id = ft.payment_details["template"]["id"]
        template = FeesTemplate.find(template_id)
        # consider ft last amounts for calculating remaing fees etc.
      else
        rem_amount = row["due"].to_i
      end


      paid = row["P1"].to_i
      fees = (paid * 100) / 118.0
      cgst = (paid - fees) / 2.0
      sgst = (paid - fees) / 2.0

      paid_data = {
        "paid" => paid,
        "discount" => 0,
        "cgst" => cgst,
        "sgst" => sgst,
        "fees" => fees,
      }

      payment_details = {
        'template' => template.slice(:id, :name, :heads),
        'paid' => { "Tution Fees"=> paid_data},
        'totals' => paid_data
      }

      FeesTransaction.create({
        org_id: org.id,
        student_id: student.id,
        academic_year: self::CURRENT_ACADEMIC_YEAR,
        comment: "imported",
        discount_amount: row["discount"].to_i || 0,
        imported: true,
        mode: "cash",
        next_due_date: Time.now + 1.month,
        paid_amount: row["P1"].to_i,
        remaining_amount: rem_amount,
        created_at: DateTime.parse(row["D1"]),
        received_by: "import",
        payment_details: payment_details,
        received_by_admin_id: Admin.first.id
      })
      putc "."
    end
  end

  # FeesTransaction.import_old_data_l2
  def self.import_old_data_l2(csv_file_path)
    csv_text = File.read(csv_file_path)
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

    csv.each do |row|
      std = {
        roll_number: row["Roll Number"],
        name: row["Name"],
        student_mobile: row["student mobile"],
        parent_mobile: row["parent mobile"]
      }

      org = Org.find 1
      student = Student.find_by(org_id: org.id, roll_number: std[:roll_number], parent_mobile: std[:parent_mobile])
      batch = Batch.find_by(org_id: org.id, id: row["Batch ID"])
      template = batch.fees_templates.first

      if student.present?
        student.batches << batch unless student.batches.ids.include?(batch.id)
      else
        random_roll_number = std[:roll_number] || Student.random_roll_number
        student = Student.create({
          roll_number: random_roll_number,
          name: std[:name],
          parent_mobile: std[:parent_mobile],
          student_mobile: std[:student_mobile],
          org_id: org.id,
          email: "_#{random_roll_number}@rcc.ned.eduaakar.com",
          password: std[:parent_mobile],
          raw_password: std[:parent_mobile]
        })

        student.batches << batch if student.errors.blank? && batch
      end

      if row["R1"].present?
        create_ft(student.id, row["P1"].to_i, clean_number(row["R1"]), row["D1"], clean_number(row["Due1"]), template, clean_number(row["Discount"]))
      end

      if row["R2"].present?
        create_ft(student.id, row["P2"].to_i, clean_number(row["R2"]), row["D2"], clean_number(row["Due2"]), template)
      end

      if row["R3"].present?
        create_ft(student.id, row["P3"].to_i, clean_number(row["R3"]), row["D3"], clean_number(row["Due"]), template)
      end

      putc "."
    end
  end

  def self.clean_number(num)
    num.gsub(",", "").to_i
  end


  def self.create_ft(student_id, paid, receipt_number, pay_date, rem_amount, template, discount = 0)
    fees = (paid * 100) / 118.0
    cgst = (paid - fees) / 2.0
    sgst = (paid - fees) / 2.0

    paid_data = {
      "paid" => paid,
      "discount" => discount,
      "cgst" => cgst,
      "sgst" => sgst,
      "fees" => fees,
    }

    payment_details = {
      'template' => template.slice(:id, :name, :heads),
      'paid' => { "Tution Fees"=> paid_data},
      'totals' => paid_data
    }

    FeesTransaction.find_or_create_by({
      org_id: Org.first.id,
      student_id: student_id,
      academic_year: self::CURRENT_ACADEMIC_YEAR,
      comment: "",
      discount_amount: 0,
      imported: true,
      mode: "cash",
      next_due_date: Time.now + 1.month,
      paid_amount: paid,
      receipt_number: receipt_number,
      remaining_amount: rem_amount,
      created_at: (DateTime.parse(pay_date) rescue nil),
      received_by: "import-ned",
      payment_details: payment_details,
      received_by_admin_id: Admin.first.id
    })
  end

  private
  def update_receipt_number
    return if self.receipt_number.present?

    if token_of_the_day < 100
      fees_transactions = FeesTransaction.lt_hundred
    else
      fees_transactions = FeesTransaction.gt_hundred
    end

    if org.rcc?
      # resetting RCC receipt numbers from 2nd July 2024
      # fees_transactions = fees_transactions.where('created_at >= ?', Date.parse("02-Jul-2024"))
      # returning alpha-numeric receipt numbers from 4rd Dec 2024
      self.receipt_number = SecureRandom.alphanumeric(10)
    else
      fees_transactions = fees_transactions.where('created_at >= ?', Date.parse("03-Dec-2023"))

      db_receipt_number = fees_transactions
        .where(org_id: org_id)
        .where(imported: false)
        .where('created_at <= ?', Time.now)
        .order(:created_at)
        .last&.receipt_number

      self.receipt_number = ((db_receipt_number.to_i || 0) + 1).to_s
    end
  end

  def update_token_of_the_day
    if student.intel_score.blank?
      count = Student.where(org_id: org_id).joins(:fees_transactions).count
      student.update(intel_score: (count % 10) < 5 ? rand(1..99) : rand(100..200))
    end

    self.token_of_the_day = student.intel_score
  end

  def self.remove_discount(student)
    ActiveRecord::Base.transaction do
      transactions = FeesTransaction.where(student_id: student.id).order(:created_at)

      last_remaining_amount = nil
      transactions.each do |transaction|
        next if transaction.is_headless

        discount = transaction.discount_amount.to_f
        if last_remaining_amount.nil?
          transaction.remaining_amount = transaction.remaining_amount + discount
        else
          transaction.remaining_amount = last_remaining_amount - (transaction.paid_amount.to_f + discount)
        end
        transaction.discount_amount = 0

        paid = transaction.payment_details['paid']['Tution Fees']
        paid['discount'] = 0
        transaction.payment_details['paid']['Tution Fees'] = paid

        totals = transaction.payment_details['totals']
        totals['discount'] = 0
        transaction.payment_details['totals'] = totals

        last_remaining_amount = transaction.remaining_amount
        transaction.save!
      end
    end
  end

  # student = Student.find 701016
  # remove_discount(student)
  # ft = FeesTransaction.where(student: student).order(:created_at).last
  # ft.remaining_amount = 120000
  # ft.save
end





# def make_entry(dt, ft, paid)
#   fees = (paid * 100) / 118.0
#   cgst = (paid - fees) / 2.0
#   sgst = (paid - fees) / 2.0


#   paid_data = {
#     "paid" => paid,
#     "discount" => 0,
#     "cgst" => cgst,
#     "sgst" => sgst,
#     "fees" => fees,
#   }

#   ft.payment_details[:paid] = { "Tution Fees"=> paid_data}
#   ft.payment_details[:totals] = paid_data
#   ft.created_at = dt
#   ft.save
# end
