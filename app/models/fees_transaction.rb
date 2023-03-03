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

      student = Student.find_by(roll_number: std[:roll_number], parent_mobile: std[:parent_mobile], student_mobile: std[:student_mobile])
      batch = Batch.find_by(id: std[:batch_id])

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
    # csv_file_path = "/Users/kapilbhosale/Downloads/L2.csv"
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


  def self.add_students
    students_data = [
      {roll_number: '9466150', name: 'Ravikant Suryakant salunke', parent_mobile: "8600524608", batch: "12th - pcm", amount: 25000, pay_date: "31/01/2023 11:18:49" },
      {roll_number: '8726941', name: 'Aditya Shashikant Kumbhar', parent_mobile: "9623070472", batch: "12th - pcb", amount: 60000, pay_date: "2/2/2023 18:29:28" },
      {roll_number: '4686199', name: 'Preeti Shrimant Waykule ', parent_mobile: "7020014484", batch: "12th - pcb", amount: 25000, pay_date: "20/01/2023 09:27:52" },
      {roll_number: '7933483', name: 'VISHAKHA GAJANAN NARWADE', parent_mobile: "9765558358", batch: "12th - pcb", amount: 25000, pay_date: "20/01/2023 10:57:28" },
      {roll_number: '2479767', name: 'Yogesh Ramesh Dondal ', parent_mobile: "7972886504", batch: "12th - pcb", amount: 25000, pay_date: "20/01/2023 11:24:55" },
      {roll_number: '9203278', name: 'Trupti Ramesh zade ', parent_mobile: "9579139887", batch: "12th - pcb", amount: 25000, pay_date: "23/01/2023 09:15:43" },
      {roll_number: '4573407', name: 'Mrunali rajaram patil', parent_mobile: "9637921588", batch: "12th - pcb", amount: 25000, pay_date: "24/01/2023 13:42:51" },
      {roll_number: '9280078', name: 'Parth Vilas Sonawane', parent_mobile: "9511242869", batch: "12th - pcb", amount: 25000, pay_date: "25/01/2023 19:44:14" },
      {roll_number: '7688156', name: 'Saavi Shrijay Kamble', parent_mobile: "9423505270", batch: "12th - pcb", amount: 25000, pay_date: "27/01/2023 19:09:41" },
      {roll_number: '6872591', name: 'ANUSHKA DEVENDRA SONWANE', parent_mobile: "9850681668", batch: "12th - pcb", amount: 25000, pay_date: "29/01/2023 15:47:46" },
      {roll_number: '8224933', name: 'Yash Deepak Avhad', parent_mobile: "7875071688", batch: "12th - pcb", amount: 60000, pay_date: "30/01/2023 18:54:48" },
      {roll_number: '6387038', name: 'SAMARTH SUDHIR KHOT', parent_mobile: "9763143433", batch: "12th - pcb", amount: 25000, pay_date: "31/01/2023 09:22:46" },
      {roll_number: '4431319', name: 'Gayatri vaijanath chapate', parent_mobile: "9623119571", batch: "12th - pcb", amount: 25000, pay_date: "6/2/2023 16:01:36" },
      {roll_number: '6438007', name: ' Tanvi Parmod Kadu', parent_mobile: "7588024779", batch: "12th - pcb", amount: 25000, pay_date: "8/2/2023 17:53:15" },
      {roll_number: '4553435', name: 'Ritesh Kailas Dhangar ', parent_mobile: "9881234807", batch: "12th - pcb", amount: 60000, pay_date: "9/2/2023 8:23:01" },
      {roll_number: '7657490', name: 'Utkarsha Hemant Borase', parent_mobile: "8806774352", batch: "12th - pcb", amount: 25000, pay_date: "9/2/2023 17:27:13" },
      {roll_number: '9429723', name: 'Halage Anal Gajanan', parent_mobile: "8624900647", batch: "12th - pcb", amount: 25000, pay_date: "9/2/2023 19:45:43" },
      {roll_number: '1918023', name: 'Vaishnavi Parmeshwar Gond', parent_mobile: "9422911621", batch: "12th - pcb", amount: 25000, pay_date: "10/2/2023 11:03:42" },
      {roll_number: '9682025', name: 'Dnyaneshwari Popat shinde', parent_mobile: "8766592671", batch: "12th - pcb", amount: 25000, pay_date: "10/2/2023 14:35:18" },
      {roll_number: '4648580', name: 'Mohammadi javed mujawar ', parent_mobile: "9850186436", batch: "12th - pcb", amount: 25000, pay_date: "10/2/2023 19:21:59" },
      {roll_number: '6312715', name: 'Pranav Jayendra Ahire', parent_mobile: "7767948526", batch: "12th - pcb", amount: 25000, pay_date: "12/2/2023 19:21:55" },
      {roll_number: '6007221', name: 'Tejaswi Kuldip Chikhale ', parent_mobile: "8805095216", batch: "12th - pcb", amount: 25000, pay_date: "16/02/2023 07:48:33" },
      {roll_number: '2035930', name: 'URVI RAJIV KUNDAP', parent_mobile: "9420772288", batch: "12th - pcb", amount: 25000, pay_date: "16/02/2023 10:31:18" },
      {roll_number: '3361331', name: 'Pranjal Prafulla Raut', parent_mobile: "8329828652", batch: "12th - pcb", amount: 25000, pay_date: "16/02/2023 16:08:21" },
      {roll_number: '8618143', name: 'Pranjal Somnath Bargal ', parent_mobile: "9822904988", batch: "12th - pcb", amount: 25000, pay_date: "17/02/2023 13:17:27" },
      {roll_number: '9960029', name: 'DIIPALI HARASHANAND WANKHEDE ', parent_mobile: "8459183149", batch: "12th - pcb", amount: 25000, pay_date: "1/2/2023 9:14:05" },
      {roll_number: '5698291', name: 'SAKSHI SANJAY SONWANE', parent_mobile: "7083175577", batch: "12th - pcb", amount: 25000, pay_date: "1/2/2023 9:33:18" },
      {roll_number: '6130637', name: 'SHUBHAM DIPAK ZARAD', parent_mobile: "9325490972", batch: "12th - pcb", amount: 25000, pay_date: "3/2/2023 14:22:22" },
      {roll_number: '1026507', name: 'Shreya Nandkishor Kale', parent_mobile: "8888208275", batch: "12th - pcb", amount: 25000, pay_date: "3/2/2023 18:50:31" },
      {roll_number: '4722752', name: 'Ansh Sudhakar Gangavane', parent_mobile: "8459463759", batch: "12th - pcb", amount: 25000, pay_date: "18/01/2023 09:22:36" },
      {roll_number: '5570307', name: 'Prachi Mahendra Bhachav', parent_mobile: "9881154880", batch: "12th - pcb", amount: 25000, pay_date: "20/01/2023 11:13:04" },
      {roll_number: '4765685', name: 'GHANEKAR SHIVAM SUNIL', parent_mobile: "8793450237", batch: "12th - pcb", amount: 25000, pay_date: "20/01/2023 17:55:51" },
      {roll_number: '9820675', name: 'Sangale Sharvari Balasaheb', parent_mobile: "9822158987", batch: "12th - pcb", amount: 25000, pay_date: "20/01/2023 18:32:54" },
      {roll_number: '5747214', name: 'Sakshi sambhaji darkunde', parent_mobile: "9545600603", batch: "12th - pcb", amount: 25000, pay_date: "21/01/2023 17:12:38" },
      {roll_number: '6065739', name: 'Omkar vitthalrao dukare', parent_mobile: "9156949949", batch: "12th - pcb", amount: 25000, pay_date: "21/01/2023 18:34:59" },
      {roll_number: '7246656', name: 'Tazkiya Madanipasha ', parent_mobile: "9922559876", batch: "12th - pcb", amount: 25000, pay_date: "26/01/2023 11:11:56" },
      {roll_number: '5807532', name: 'Kashid Samruddhi Mahenda', parent_mobile: "9689979067", batch: "12th - pcb", amount: 25000, pay_date: "26/01/2023 12:38:41" },
      {roll_number: '8171291', name: 'Parth Chandrakant Roplekar', parent_mobile: "8805548121", batch: "12th - pcb", amount: 25000, pay_date: "28/01/2023 12:23:00" },
      {roll_number: '2930048', name: 'Vedant Dhananjay Sonune', parent_mobile: "9420146379", batch: "12th - pcb", amount: 25000, pay_date: "28/01/2023 12:34:41" },
      {roll_number: '8425080', name: 'Jaydatta santosh waghmare ', parent_mobile: "9156146216", batch: "12th - pcb", amount: 25000, pay_date: "29/01/2023 18:00:18" },
      {roll_number: '9398819', name: 'Atharv Appaso Bhosale', parent_mobile: "9921013074", batch: "12th - pcb", amount: 25000, pay_date: "30/01/2023 17:44:31" },
      {roll_number: '5401688', name: 'Londhe janhavi Rajendra', parent_mobile: "9146806077", batch: "12th - pcb", amount: 60000, pay_date: "31/01/2023 17:24:11" },
      {roll_number: '3559450', name: 'Shivam Amol Tandale', parent_mobile: "9422931339", batch: "12th - pcb", amount: 25000, pay_date: "5/2/2023 17:37:29" },
      {roll_number: '3516387', name: 'Shruti Gorakshnath Mhaske', parent_mobile: "8378981041", batch: "12th - pcb", amount: 25000, pay_date: "7/2/2023 16:04:01" },
      {roll_number: '7328271', name: 'Ku. Pranjali Kailas Bhonde', parent_mobile: "9970272628", batch: "12th - pcb", amount: 25000, pay_date: "7/2/2023 11:08:09" },
      {roll_number: '9441866', name: 'Amey Vikas Vairal', parent_mobile: "7028655848", batch: "12th - pcb", amount: 25000, pay_date: "8/2/2023 15:51:24" },
      {roll_number: '4774694', name: 'Vikas Anil Pandit', parent_mobile: "9158014623", batch: "12th - pcb", amount: 25000, pay_date: "8/2/2023 16:27:05" },
      {roll_number: '3169283', name: 'Arjun Sandip Pandit', parent_mobile: "9158875690", batch: "12th - pcb", amount: 25000, pay_date: "8/2/2023 17:02:59" },
      {roll_number: '1605465', name: 'Tanvi Sharad Shinde', parent_mobile: "7030032436", batch: "12th - pcb", amount: 25000, pay_date: "8/2/2023 18:11:22" },
      {roll_number: '2532858', name: 'Nandinee Kamalakar Patil ', parent_mobile: "9860862483", batch: "12th - pcb", amount: 25000, pay_date: "9/2/2023 10:51:10" },
      {roll_number: '9776521', name: 'Shraddha santosh patil', parent_mobile: "9764553000", batch: "12th - pcb", amount: 25000, pay_date: "9/2/2023 12:10:49" },
      {roll_number: '1046704', name: 'Rushikesh dadarao Mavhare', parent_mobile: "9075505455", batch: "12th - pcb", amount: 25000, pay_date: "9/2/2023 15:00:17" },
      {roll_number: '9511287', name: 'Shreya Bhagwat Yeul', parent_mobile: "9850086903", batch: "12th - pcb", amount: 25000, pay_date: "9/2/2023 16:30:18" },
      {roll_number: '5769775', name: 'SUYASH BALAJI BARVE', parent_mobile: "9657698818", batch: "12th - pcb", amount: 25000, pay_date: "10/2/2023 14:11:42" },
      {roll_number: '4123150', name: 'Mohini chandu sable', parent_mobile: "9594994096", batch: "12th - pcb", amount: 25000, pay_date: "10/2/2023 14:12:57" },
      {roll_number: '7364705', name: 'Purva Machhindranath Shewale ', parent_mobile: "8805777005", batch: "12th - pcb", amount: 25000, pay_date: "10/2/2023 14:21:41" },
      {roll_number: '1463360', name: 'Sumit Rambhau Solanke', parent_mobile: "9765985583", batch: "12th - pcm", amount: 25000, pay_date: "9/2/2023 12:25:17" },
      {roll_number: '7866558', name: 'Bhalerao Shivam Shivaji', parent_mobile: "9518507214", batch: "12th - pcb", amount: 25000, pay_date: "10/2/2023 17:50:04" },
      {roll_number: '5852657', name: 'Gargi Vijay Harale', parent_mobile: "9767886581", batch: "12th - pcb", amount: 25000, pay_date: "10/2/2023 18:43:24" },
      {roll_number: '5151178', name: 'Sayali Ekanath patil', parent_mobile: "9922352968", batch: "12th - pcb", amount: 25000, pay_date: "12/2/2023 17:53:50" },
      {roll_number: '8835245', name: 'Onkar Umesh Jadhav ', parent_mobile: "9096330469", batch: "12th - pcb", amount: 25000, pay_date: "14/02/2023 11:35:36" },
      {roll_number: '6546588', name: 'SUVARNA ANIL SHELKE', parent_mobile: "9158338826", batch: "12th - pcb", amount: 25000, pay_date: "17/02/2023 10:05:49" },
      {roll_number: '6130680', name: 'Tanaya Avinash Darkunde', parent_mobile: "9011828379", batch: "12th - pcb", amount: 25000, pay_date: "17/02/2023 12:46:07" },
      {roll_number: '9983804', name: 'Sanvi santosh dhaniwale', parent_mobile: "9921459744", batch: "12th - pc", amount: 25000, pay_date: "19/02/2023 11:50:00" },
      {roll_number: '8633075', name: 'Pawan Santosh Harkar', parent_mobile: "9923942513", batch: "12th - pcb", amount: 25000, pay_date: "17/02/2023 16:57:49" },
      {roll_number: '6018486', name: 'Dipika Pruthvising Padvi', parent_mobile: "9423823103", batch: "12th - pcb", amount: 25000, pay_date: "17/02/2023 17:22:49" },
      {roll_number: '3036874', name: 'Yash Rajesh Kadadi', parent_mobile: "9423535398", batch: "12th - pcb", amount: 25000, pay_date: "18/02/2023 10:03:03" },
      {roll_number: '6150000', name: 'Shital sanjay rupnar', parent_mobile: "9766974509", batch: "12th - pcb", amount: 25000, pay_date: "18/02/2023 10:16:02" },
      {roll_number: '8237787', name: 'Amruta Dronacharya Kokate ', parent_mobile: "9960601394", batch: "12th - pcb", amount: 25000, pay_date: "18/02/2023 18:26:00" },
      {roll_number: '5821052', name: 'Siddhi Hiraman Shingote ', parent_mobile: "8698967820", batch: "12th - pcb", amount: 25000, pay_date: "18/02/2023 19:03:49" },
      {roll_number: '4898837', name: 'Prachi Pandurang Bhosale', parent_mobile: "9137646414", batch: "12th - pcb", amount: 25000, pay_date: "18/02/2023 21:17:25" },
      {roll_number: '9599419', name: 'Mrunali Baswaraj Swami', parent_mobile: "7020287011", batch: "12th - pcb", amount: 25000, pay_date: "19/02/2023 11:11:15" },
      {roll_number: '3652794', name: 'Namrata Nagesh Sitap', parent_mobile: "9850847654", batch: "12th - pcb", amount: 25000, pay_date: "19/02/2023 11:57:47" },
      {roll_number: '3786478', name: 'Jidnyasa Hemant Pagare', parent_mobile: "9420209462", batch: "12th - pcb", amount: 25000, pay_date: "19/02/2023 12:53:44" },
      {roll_number: '6313102', name: 'Anuja Mahadev Binwade', parent_mobile: "9420810043", batch: "12th - pcb", amount: 25000, pay_date: "19/02/2023 14:54:06" },
      {roll_number: '9229563', name: 'Arpita Purushottam Hade', parent_mobile: "7350078501", batch: "12th - pcb", amount: 25000, pay_date: "19/02/2023 14:59:23" },
      {roll_number: '6089867', name: 'Yash Sandeep Vasagadekar', parent_mobile: "9545608699", batch: "12th - pcb", amount: 25000, pay_date: "19/02/2023 17:02:36" },
      {roll_number: '2133902', name: 'PRITI PRAPHULLA KACHARE', parent_mobile: "9595125416", batch: "12th - pcb", amount: 25000, pay_date: "19/02/2023 17:26:08" },
      {roll_number: '4990657', name: 'Mahammad Akram Tajuddin Mulani ', parent_mobile: "7769941425", batch: "12th - pcb", amount: 25000, pay_date: "19/02/2023 19:32:09" },
      {roll_number: '8482801', name: 'Anushka Balaji Dahiphale ', parent_mobile: "9850360444", batch: "12th - pcb", amount: 25000, pay_date: "20/02/2023 08:20:24" },
      {roll_number: '4945783', name: 'Shravani Pradip Wakhure ', parent_mobile: "9823077772", batch: "12th - pcb", amount: 25000, pay_date: "20/02/2023 10:36:47" },
      {roll_number: '7989660', name: 'Vivek vijay kokani', parent_mobile: "7020298838", batch: "12th - pcb", amount: 25000, pay_date: "20/02/2023 10:37:36" },
      {roll_number: '6112856', name: 'Anushka ajit Mandlik ', parent_mobile: "9762677302", batch: "12th - pcb", amount: 25000, pay_date: "20/02/2023 11:33:34" },
      {roll_number: '4909139', name: 'Suyash Tulshiram Gaikwad', parent_mobile: "9028779101", batch: "12th - pcb", amount: 25000, pay_date: "20/02/2023 11:38:17" },
      {roll_number: '5206641', name: 'Shravani Yeshwant Bandre', parent_mobile: "9420864447", batch: "12th - pcb", amount: 25000, pay_date: "20/02/2023 12:18:32" },
      {roll_number: '4221256', name: 'SANKET SANTOSH JAWARE', parent_mobile: "9529819349", batch: "12th - pcb", amount: 25000, pay_date: "20/02/2023 14:18:09" },
      {roll_number: '1021575', name: 'NAYBAL TEJSWINI ADINATH', parent_mobile: "9673143516", batch: "12th - pcb", amount: 25000, pay_date: "20/02/2023 14:28:03" },
      {roll_number: '9551567', name: 'Mahesh Shankar Jadhav', parent_mobile: "8788017554", batch: "12th - pcb", amount: 25000, pay_date: "20/02/2023 15:52:58" },
      {roll_number: '9833727', name: 'Darshika Dharasing Jadhav', parent_mobile: "9503917178", batch: "12th - pcb", amount: 25000, pay_date: "20/02/2023 15:53:08" },
      {roll_number: '2481317', name: 'Viraj Shrikant Misal', parent_mobile: "8999391162", batch: "12th - pcb", amount: 60000, pay_date: "20/02/2023 15:57:26" },
      {roll_number: '2432602', name: 'Dipak Sheshnarayan Gonde', parent_mobile: "9822707616", batch: "12th - pcb", amount: 25000, pay_date: "20/02/2023 16:42:39" },
      {roll_number: '1223817', name: 'Chaitali Ramchandra Patil', parent_mobile: "7507617547", batch: "12th - pcb", amount: 60000, pay_date: "20/02/2023 17:41:48" },
      {roll_number: '4606195', name: 'Dhananjay Vilasrao Jagtap ', parent_mobile: "9422083432", batch: "12th - pcb", amount: 60000, pay_date: "20/02/2023 18:30:35" },
      {roll_number: '4549659', name: 'Mahin salim lakhe', parent_mobile: "7559123223", batch: "12th - pcb", amount: 25000, pay_date: "20/02/2023 19:38:02" },
      {roll_number: '9555278', name: 'RUCHITA RAMDAS SOLANKI', parent_mobile: "7588833574", batch: "12th - pcb", amount: 25000, pay_date: "20/02/2023 20:40:54" },
      {roll_number: '7373383', name: 'Anagha Sanjay Kadam', parent_mobile: "8600600251", batch: "12th - pcb", amount: 25000, pay_date: "20/02/2023 22:33:04" },
      {roll_number: '9135853', name: 'Akshay Shrishail Mali', parent_mobile: "9284245224", batch: "12th - pcb", amount: 25000, pay_date: "21/02/2023 08:16:49" },
      {roll_number: '3437604', name: 'Vaishnavi pralhad Nagre', parent_mobile: "9022668900", batch: "12th - pcb", amount: 25000, pay_date: "21/02/2023 10:52:38" },
      {roll_number: '8445262', name: 'Srushti Suhas ghule', parent_mobile: "9822475286", batch: "12th - pcb", amount: 60000, pay_date: "21/02/2023 11:12:10" },
      {roll_number: '3469194', name: 'Soham Navnath Tale', parent_mobile: "9146613059", batch: "12th - pc", amount: 25000, pay_date: "21/02/2023 12:38:45" },
      {roll_number: '5337148', name: 'Aviraj vithoba waghmare', parent_mobile: "9623667153", batch: "12th - pc", amount: 25000, pay_date: "21/02/2023 14:12:02" },
      {roll_number: '5935928', name: 'Kshitij Sachin Akolkar ', parent_mobile: "9604767868", batch: "12th - pc", amount: 25000, pay_date: "21/02/2023 16:04:56" },
      {roll_number: '3037091', name: 'Naziya Deshmukh', parent_mobile: "9922145385", batch: "12th - pc", amount: 25000, pay_date: "21/02/2023 17:27:35" },
      {roll_number: '7401217', name: 'Pradnya ramdas lamb ', parent_mobile: "9075663772", batch: "12th - pcb", amount: 25000, pay_date: "21/02/2023 13:11:29" },
      {roll_number: '8067685', name: 'Bhakti Naganath Bidave ', parent_mobile: "9860128950", batch: "12th - pcb", amount: 25000, pay_date: "21/02/2023 14:23:55" },
      {roll_number: '1956440', name: 'Mujawar Arshiya Fatema Shoukat', parent_mobile: "9765373000", batch: "12th - pcb", amount: 25000, pay_date: "21/02/2023 15:09:48" },
      {roll_number: '6220378', name: 'Shravani Sandip Gaikwad ', parent_mobile: "9765709898", batch: "12th - pcb", amount: 25000, pay_date: "21/02/2023 16:49:50" },
      {roll_number: '7322370', name: 'Pranav Madhav Kute', parent_mobile: "9730737208", batch: "12th - pcb", amount: 25000, pay_date: "21/02/2023 17:15:37" },
      {roll_number: '6786709', name: 'Hrigved Mahesh Kulkarni', parent_mobile: "8830868098", batch: "12th - pcb", amount: 25000, pay_date: "21/02/2023 18:42:41" },
      {roll_number: '8113220', name: 'Dnyaneshwari Balasaheb Bade', parent_mobile: "9130005799", batch: "12th - pcb", amount: 25000, pay_date: "21/02/2023 19:30:20" },
      {roll_number: '3106584', name: 'Pramod Ramhari Gite', parent_mobile: "9403902877", batch: "12th - pcb", amount: 25000, pay_date: "21/02/2023 20:28:22" },
      {roll_number: '7236084', name: 'PRANAV BHIMRAO SURYAWANSHI ', parent_mobile: "8308777882", batch: "12th - pcb", amount: 25000, pay_date: "21/02/2023 22:32:57" },
      {roll_number: '9081661', name: 'Chate abhishek arun', parent_mobile: "8208777754", batch: "12th - pcb", amount: 25000, pay_date: "22/02/2023 09:20:51" },
      {roll_number: '4739664', name: 'Pranav Raju Gosavi', parent_mobile: "9356417008", batch: "12th - pcb", amount: 10000, pay_date: "1/1/2023 0:00:00" }
    ]

    batch_ids = {
      "12th - pcb" => Batch.find_by(id: 819),
      "12th - pc" => Batch.find_by(id: 820),
      "12th - pcm" => Batch.find_by(id: 822)
    }

    total_fees = {
      "12th - pcb" => 60_000,
      "12th - pc" => 50_000,
      "12th - pcm" => 60_000
    }

    not_found = []
    students_data.each do |std|
      student = Student.find_by(roll_number: std[:roll_number], parent_mobile: std[:parent_mobile])
      unless student
        not_found << std
        next
      end

      batch = batch_ids[std[:batch]]
      template = batch.fees_templates.first

      paid = std[:amount].to_i
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

      rem_amount = total_fees[std[:batch]] - paid

      FeesTransaction.create({
        org_id: Org.first.id,
        student_id: student.id,
        academic_year: "2023-24",
        comment: "",
        discount_amount: 0,
        imported: true,
        mode: "cash",
        next_due_date: Time.now + 1.month,
        paid_amount: paid,
        receipt_number: rand(100...200),
        remaining_amount: rem_amount,
        created_at: DateTime.parse(std[:pay_date]),
        received_by: "import-online",
        payment_details: payment_details,
        received_by_admin_id: Admin.first.id
      })
      putc "."
    end

    puts "------------"
    puts not_found
    puts "------------"
  end

  private
  def update_receipt_number
    return if self.receipt_number.present?

    if token_of_the_day < 100
      fees_transactions = FeesTransaction.lt_hundred
    else
      fees_transactions = FeesTransaction.gt_hundred
    end

    db_receipt_number = fees_transactions
      .where(org_id: org_id)
      .where(imported: false)
      .order(:created_at)
      .last&.receipt_number

    self.receipt_number = ( db_receipt_number || 0) + 1
  end

  def update_token_of_the_day
    if student.intel_score.blank?
      count = Student.where(org_id: org_id).joins(:fees_transactions).count
      student.update(intel_score: (count % 10) < 5 ? rand(1..99) : rand(100..200))
    end

    self.token_of_the_day = student.intel_score
  end
end
