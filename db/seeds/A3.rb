batch = Batch.find_or_create_by(name: 'A3')
batch_A3 = [
    '19512,Bangad Vivekanand Murlimanohar,8087274779',
    '19513,Bargale Sumit Shital,7588490222',
    '19514,Bhagwat Aryash Nitin,9011024477',
    '19515,Bhandare Shriprem,9158070761',
    '19516,Bharadia Rahul Sanjay,9823185204',
    '19517,Bhosale Rutvik Maruti,7517283810',
    '19518,Chougule Nikhil Rajkumar,9975335181',
    '19501,Chougule Ritika Rahul,9850963838',
    '19519,Dattwade Suyash Ravindra,9673020809',
    '19520,Dhavale Shivraj Suryakant,9423535442',
    '19521,Dhotre Parth Sachin,9561501111',
    '19553,Divate Ashishi Krishna,8788511684',
    '19502,Erandole Aarati Umesh,9423839554',
    '19522,Ganjave Shreyas Ananda,7588255532',
    '19503,Gondhali Chaitra Kamraj,7249495298',
    '19523,Goundaje Nishank Pramod,9422576648',
    '19524,Hogade Prathamesh Bharatkumar,9822324116',
    '19525,Jadhav Gaurav Nivas,9922510324',
    '19526,Jadhav Prathamesh Vallabh,9960734609',
    '19527,Jagdale Sourabh Rajendra,8806003795',
    '19528,Jain Anikit Rajendra,9422044845',
    '19529,Joshi Sanchit Govind,9689555261',
    '19530,Kamble Rohit Sadashiv,9960197016',
    '19531,Khandare Kunal Manjunath,9922810357',
    '19504,Khot Vividha Vinod,9881438288',
    '19505,Kole Bela Sanjay,9822277464',
    '19532,Kulkarni Raghavendra Rajendra,8975594816',
    '19533,Kumbhar Vinayak Vaibhav,9923092020',
    '19534,Magdum Niranjan Sudhir,9975847417',
    '19535,Mali Abhishek Gajanan,9325840148',
    '19536,Mali Pratyesh Surendra,9822410604',
    '19537,Mali Rushikesh Maruti,9075917193',
    '19506,Mali Snehal Kumar,9130087733',
    '19538,Malwade Ashwin Vinayak,9325241089',
    '19539,Miraje Niraj Rajendra,9130906807',
    '19540,Miraje Sachin Chidanand,8421487980',
    '19541,Mujawar Muddassar Faruddin,9764446988',
    '19542,Mulla Izaz Mubarak,7057989991',
    '19543,Mutha Sanklap Anil,9763609538',
    '19544,Nemgonda Saurabh Subhash,9763998274',
    '19545,Pandharpatte Akash,8390839665',
    '19546,Pareek Omkar Gopal,9881425194',
    '19547,Patil Ashish Ramesh,7875486280',
    '19548,Patil Ashish Shamrao,9049953744',
    '19549,Patil Mahesh Annaso,7709115505',
    '19550,Patil Swapnil Lahu,9096382580',
    '19507,Patni Shanu Ajitji,9764381033',
    '19551,Prasad Aman Tilakhari,8855880591',
    '19508,Sapkal Sayali Sanjay,9850818203',
    '19509,Sokashe Saloni Dipak,9422414582',
    '19510,Solase Sakshi Subhash,8999260610',
    '19511,Swami Sanchita Sanjay,9921683366',
    '19552,Tare Shreyash Sandeep,9422045509',
]

batch_A3.each do |row|
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
