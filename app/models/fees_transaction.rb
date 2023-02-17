# == Schema Information
#
# Table name: fees_transactions
#
#  id                   :uuid             not null, primary key
#  academic_year        :string
#  comment              :string
#  discount_amount      :decimal(, )      default(0.0)
#  imported             :boolean          default(FALSE)
#  mode                 :string
#  next_due_date        :date
#  paid_amount          :decimal(, )      default(0.0)
#  payment_details      :jsonb
#  receipt_number       :integer          not null
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
    current_template_id = fees_transactions.order(:created_at).last.payment_details.dig('template', 'id')
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
      gender: student.gender == 0 ? 'Male' : 'Female' ,
      batch: student.batches.joins(:fees_templates).pluck(:name).join(', '),
      receipt_number: receipt_number,
      paid_amount: paid_amount.to_f,
      base_fee: paid_amount + remaining_amount,
      cgst: payment_details.dig('totals', 'cgst').to_f,
      sgst: payment_details.dig('totals', 'sgst').to_f,
      tax: payment_details.dig('totals', 'cgst').to_f + payment_details.dig('totals', 'sgst').to_f,
      collected_by: admin.name,
      remaining_amount: remaining_amount.to_f,
      discount_amount: discount_amount.to_f,
      discount_comment: comment
    }
  end

  BATCH_MAPPING = {
    "12th (PCB) 2023-24" => 819,
    "12th (PCM) 2023-24" => 822,
    "12th (Phy+Chem) 2023-24" => 820,
    "12th (Chem) 2023-24" => 821,
    "11th (PCB) 2023-24" => 837,
    "11th (Phy+Chem) 2023-24" => 838,
    "11th (PCM) 2023-24" => 840
  }

  # FeesTransaction.import_old_data
  def self.import_old_data(csv_file_path)
    # csv_file_path = "/Users/kapilbhosale/Downloads/L-test.csv"
    csv_text = File.read(csv_file_path)
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    sorted_csv = CSV::Table.new(csv.sort_by { |row| row["Receipt No"].to_i})

    batches_by_id = Batch.where(id: BATCH_MAPPING.values).index_by(&:id)

    sorted_csv.each do |row|
      std = {
        roll_number: row["Roll Number"],
        name: row["Name"],
        student_mobile: row["student mobile"],
        parent_mobile: row["parent mobile"]
      }

      student = Student.find_by(parent_mobile: std[:parent_mobile], student_mobile: std[:student_mobile])
      batch = Batch.find_by(id: 819)

      if student.present? && FeesTransaction.where(student_id: student.id).present?
        batch = student.batches.joins(:fees_templates).first
        template = batch.fees_templates.first
      else
        random_roll_number = Student.random_roll_number
        student = Student.create({
          roll_number: random_roll_number,
          name: std[:name],
          parent_mobile: std[:parent_mobile],
          student_mobile: std[:student_mobile],
          org_id: 1,
          email: "_#{random_roll_number}@rcc.eduaakar.com",
          password: std[:parent_mobile],
          raw_password: std[:parent_mobile]
        })

        if student.errors.blank?
          batch = batches_by_id[BATCH_MAPPING[row["Batch"]]]
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
        if row["Status"] == "Nill" || row["due"].to_i == 0
          rem_amount = 0
        else
          rem_amount = row["due"].to_i
        end
      end


      paid = row["paid"].to_i
      fees = (paid * 100) / 118.0
      cgst = (paid - fees) / 2.0
      sgst = (paid - fees) / 2.0

      paid_data = {
        "paid" => paid,
        "discount" => row["discount"].to_i || 0,
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
        org_id: Org.first.id,
        student_id: student.id,
        academic_year: self::CURRENT_ACADEMIC_YEAR,
        comment: row["Comment"],
        discount_amount: row["discount"].to_i || 0,
        imported: true,
        mode: "cash",
        next_due_date: Time.now + 1.month,
        paid_amount: row["paid"].to_i,
        receipt_number: row["Receipt No"],
        remaining_amount: rem_amount,
        created_at: DateTime.parse(row["pay date"]),
        received_by: "import",
        payment_details: payment_details,
        received_by_admin_id: Admin.first.id
      })
      putc "."
    end
  end

  # FeesTransaction.import_old_data_l2
  def self.import_old_data_l2(csv_file_path)
    csv_file_path = "/Users/kapilbhosale/Downloads/L2.csv"
    csv_text = File.read(csv_file_path)
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    # sorted_csv = CSV::Table.new(csv.sort_by { |row| row["Receipt No"].to_i})

    batches_by_id = Batch.where(id: BATCH_MAPPING.values).index_by(&:id)

    csv.each do |row|
      std = {
        roll_number: row["Roll Number"],
        name: row["Name"],
        student_mobile: row["student mobile"],
        parent_mobile: row["parent mobile"]
      }

      batch = Batch.find_by(id: 819)
      # batch = Batch.find_by(id: 5)

      random_roll_number = Student.random_roll_number
      student = Student.create({
        roll_number: random_roll_number,
        name: std[:name],
        parent_mobile: std[:parent_mobile],
        student_mobile: std[:student_mobile],
        org_id: 1,
        email: "_#{random_roll_number}@rcc.eduaakar.com",
        password: std[:parent_mobile],
        raw_password: std[:parent_mobile]
      })

      if student.errors.blank?
        batch = batches_by_id[BATCH_MAPPING[row["Batch"]]]
        student.batches << batch if batch
      end
      template = batch.fees_templates.first

      if row["R1"].present?
        create_ft(student.id, row["P1"].to_i, row["R1"], row["D1"], row["Due1"], template)
      end

      if row["R2"].present?
        create_ft(student.id, row["P2"].to_i, row["R2"], row["D2"], row["Due2"], template)
      end

      if row["R3"].present?
        create_ft(student.id, row["P3"].to_i, row["R3"], row["D3"], row["Due"], template)
      end

      putc "."
    end
  end


  def self.create_ft(student_id, paid, receipt_number, pay_date, rem_amount, template)
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
      created_at: DateTime.parse(pay_date),
      received_by: "import",
      payment_details: payment_details,
      received_by_admin_id: Admin.first.id
    })
  end

  private
  def update_receipt_number
    return if self.receipt_number.present?

    if token_of_the_day < 100
      self.receipt_number = (FeesTransaction.lt_hundred.where(org_id: org_id).order(:created_at).last&.receipt_number || 0) + 1
    else
      self.receipt_number = (FeesTransaction.gt_hundred.where(org_id: org_id).order(:created_at).last&.receipt_number || 0) + 1
    end
  end

  def update_token_of_the_day
    if student.intel_score.blank?
      count = Student.where(org_id: org_id).joins(:fees_transactions).count
      student.update(intel_score: (count % 10) < 5 ? rand(1..99) : rand(100..200))
    end

    self.token_of_the_day = student.intel_score
  end
end
