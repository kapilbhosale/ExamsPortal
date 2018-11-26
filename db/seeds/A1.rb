batch = Batch.find_or_create_by(name: 'A1')
batch_A1 = [
'19101,Akiwate Anuja Suresh,9970695999',
'19160,Awati Priti Pradip,8208161860',
'19102,Bagane Aryan Nilesh,8805040441',
'19103,Bagawade Rushikesh Prashant,9421286971',
'19104,Bhagat Shrishail Kiran,7276777804',
'19105,Bhosale Rutuja,9448163905',
'19106,Bonage Chirag Mahesh,8888619933',
'19107,Buchade Anirudha Bhaskar,9822594730',
'19108,Bugad Janhavi Jitendra,9922666677',
'19109,Bugad Parth Pavan,9923754716',
'19110,Bugad Soham Dhananjay,9763527573',
'19111,Chougule Pratik Dhanpal,9423816189',
'19112,Chougule Saniya Sunil,9611724232',
'19113,Chougule Shraddha Sanjay,8888098899',
'19114,Danole Sumod Vidyasagar,9921113447',
'19163,Desai Jaydeep Sarjerao,9881534077',
'19115,Desai Takshak Vikram,9420953343',
'19116,Dhamane Rohit R.,8055669696',
'19117,Dhanale Omkar Raju,9822977517',
'19118,Dhavale Sourabh Sunil,9011998700',
'19119,Gare Sanjana Sanjay,9420879542',
'19164,Gavali Prashik Kisan,9881371078',
'19120,Ghatage Akanksha Bajrang,9822269752',
'19161,Ghode Namrata Vitthal,9922329242',
'19167,Gore Digvijay Dhananjay,7776924256',
'19121,Gurav Tejas Hanmant,9075981454',
'19162,Hogade Prem Subhash,9422415385',
'19122,Huded Shivraj Dayanand,8421188277',
'19168,Hujare Sanket Pandurang,8329794010',
'19123,Ingale Shreyanshnath Shantinath,9822709845',
'19124,Joshi Shreyas Sandip,9890674748',
'19125,Kalawant Saniya Sunil,7447814041',
'19126,Kamble Abhijeet Dilip,9552652682',
'19127,Kamble Siddhart C.,9665754295',
'19128,Karyappa Yash Sukumar,9421101105',
'19129,Khavat Samarth Sachin,9922347888',
'19172,Khot Girish Rajaram,9371921215',
'19169,Khot Shreyash Laxman,9423292975',
'19165,Kolekar Aditya Mahesh,9011424414',
'19130,Kuchekar Anjali Shivanand,9730093009',
'19131,Kukreja Sohan Gopi,9423316222',
'19132,Kumbhar Karan Pandurang,9326020030',
'19133,Kumbhar Rutuja Raju,9588465364',
'19134,Mali Yash Dipak,9922221543',
'19135,Manwade Ganesh Balmukund,7057700769',
'19136,Maskar Swapnali Jitendra,7745022730',
'19137,Mulla Muhafij Nasir,9130401479',
'19138,Nagargoje Kundan Ishwar,9689901588',
'19173,Nagure Abhinav,9011799414',
'19139,Nalawade Satyajeet Shashikant,9860858151',
'19140,Neje Prathamesh Sidgounda,9326557263',
'19141,Parit Pratiksha Shivaji,9822242077',
'19142,Patil Anuja Ashok,9421100445',
'19143,Patil Himanshu Vishwanath,9975098573',
'19144,Patil Pratik Ashok,7709904686',
'19145,Patil Rohit Ramgonda,9503042203',
'19166,Patil Sandesh Rajgonda,9766378282',
'19146,Patil Utkarsha Charudatt,7774948541',
'19170,Paymal Sakshi Shivaji,9511816808',
'19147,Rajmane Abhishek Dadaso,9822119065',
'19148,Rajput Rajat Uttamsing,9823157675',
'19149,Saluja Harsharanjeetsingh  K.,8668354821',
'19150,Sathe Prathamesh Bhaskar,9763727759',
'19151,Sawant Vrushaket Vijay,7385171642',
'19152,Shelake Ritu Chandrakant,7350963340',
'19171,Shetake Navin Ashok,9423284022',
'19153,Sutar Atharva Ramchandra,9860807952',
'19154,Todkar Shreyas Suresh,9156144671',
'19155,Udgave Ekta Pravin,9272894709',
'19156,Urane Ekta Kailash,8055566105',
'19157,Vankudre Goutam Sunil,9423858288',
'19158,Veer Janvi Bhanudas,9822316722',
'19159,Wani Varsha Vijay,9011829966',
]

batch_A1.each do |row|
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
