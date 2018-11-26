batch = Batch.find_or_create_by(name: 'A2')
batch_A2 = ['19201,Akkole Ashutosh Nandkumar,9822009142',
           '19202,Attar Aquil Abdul Hamid,7775989340',
           '19203,Baldawa Aayushi Pravin,9420425392',
           '19204,Bavache Chetan Prakash,9881590023',
           '19205,Belgaokar Pruthvi Vikas,9421206688',
           '19206,Bhairsora Sahil Rameshsingh,7385856726',
           '19207,Bidre Tejas Anil,9623459769',
           '19208,Biyani Shubham R.,9423595831',
           '19209,Bohara Umakant Mahesh,9028956490',
           '19210,Chandekar Prathamesh Shivaji,9767495535',
           '19211,Dambal Jayateerth Shyam,9923133033',
           '19212,Dhotre Anushka Ashok,9326008090',
           '19213,Dodamani Sachin Basavraj,9588635848',
           '19214,Farande Vishal Arun,7387245150',
           '19218,Hadpad Shirish Manohar,7875229292',
           '19221,Jaju Sahil Suresh,9421286747',
           '19222,Joshi Vishal Dineshkumar,9765876359',
           '19223,Joshi Yadney Ashok,9028084874',
           '19224,Kage Sammed Shantinath,9518912765',
           '19225,Kale Sanket Sanjay,9423766118',
           '19226,Kawade Kaushal Abhay,9730041614',
           '19227,Khatavkar Harshvardhan Pramod,9850974440',
           '19228,Khool Dikshant Kumar,8087073637',
           '19229,Khot Audumbar Murari,9657278590',
           '19232,Killedar Srushti Arvind,9420134834',
           '19233,Kole Shrutika Nishikant,9545682155',
           '19235,Koli Shubham Suresh,9326014012',
           '19236,Kshirsagar Sachin Dhondiram,8805904018',
           '19237,Kulkarni Gandhar Uday,9422625575',
           '19238,Laddha Goutam Gokul,9765737966',
           '19239,Mali Hemant Avinash,9011819500',
           '19240,Mali Pratik Vijaykumar,9960045209',
           '19241,Mandavkar Shreyash Prashant,9420586062',
           '19242,Mantri Aditi Rakesh,9404269525',
           '19243,Mehta Bhavesh Pankaj,9423286703',
           '19244,More Sanket Sambhaji,9823720355',
           '19245,Mudgal Manorama Shivaji,8421213533',
           '19246,Navale Manish Madan,9822212544',
           '19247,Neje Shyamali Satappa,9921059645',
           '19248,Nerlekar Soujanya Balasaheb,9271755771',
           '19249,Pareek Rahul Vitthal,9371120961',
           '19250,Patange Rushikesh Kedarnath,7385345323',
           '19251,Patil Ayush Chandrakant,9850862370',
           '19252,Patil Pranav Vitthal,9075876767',
           '19253,Patil Satyajeet Vikas,9403771828',
           '19255,Pujari Shreya Balkrishna,9422044095',
           '19256,Sabale Abhishek Jalindar,9604008314',
           '19257,Sakhare Abhishek Eknath,9561474952',
           '19258,Shaikh Abrarulhak Yasin,9763287946',
           '19268,Sherkhane Priyanka,9960183696',
           '19260,Shete Yash Atul,9766788997',
           '19261,Shinde Shahu Vishnu,9823226139',
           '19262,Shirke Kshitija Suresh,7972817808',
           '19263,Shirvalkar Atharv Mahesh,9422043680',
           '19264,Terwadkar Atharv Vaman,9822955896',
           '19265,Tipugade Vedang Krishna,9423286679',
           '19266,Urane Harshvardhan Dnyaneshwar,9921112922',
           '19267,Vedphatak Pavankumar Vijay,9890071191'
]

batch_A2.each do |row|
  data = row.split(',')
  email = "#{data[0]}@se.com"
  student = Student.find_or_initialize_by(email: email)
  student.roll_number = data[0]
  rand_password = ('0'..'9').to_a.shuffle.first(6).join
  student.password = rand_password
  student.raw_password = rand_password
  student.name = data[1]
  student.parent_mobile = data[2] || ('0'..'9').to_a.shuffle.first(10).join
  student.save
  StudentBatch.create(student: student, batch: batch)
  puts "Adding student - #{email}"
end
