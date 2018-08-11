batch = Batch.find_or_create_by(name: 'A')
batch_A = ['2201,SHINDE SHUBHAM VITTHALRAO,Male,9764137892,A',
           '2202,DAREKAR VAIBHAV DATTATRAYA,Male,9552843507,A',
           '2203,AITANBONE RUTUJAKUMARI HARISHCHANDRA,Female,9730347049,A',
           '2204,ALMALE VAISHNAVI DAGDU,Female,8698006916,A',
           '2205,MORE SANJANA KAKASAHEB,Female,9665522300,A',
           '2206,LAHANE ASHUTOSH JAGANNATH,Male,9921563909,A',
           '2207,BADE RUTUJA NAVNATH,Female,7709781993,A',
           '2208,BALGULE KOMAL DAYANDEO,Female,9527449530,A',
           '2209,BANATE PREETI UMAKANT,Female,9421367064,A',
           '2210,BANDE VAIBHAV MADHUKAR,Male,7756963061,A',
           '2211,BANGAD NETAL SANTOSH,Female,7588208019,A',
           '2212,BANSODE SUPRIYA SATISH,Female,9420871255,A',
           '2214,BELE AKANKSHA SUGRIV ,Female,9421485176,A',
           '2215,BHAD GOURAV DEEPAK ,Male,9422654017,A',
           '2216,SHINDE SAURABH BALAJI,Male,9922768591,A',
           '2217,BHETE MAYURI RAJESHWAR,Female,8237625171,A',
           '2218,BHOJANE ATUL GOPAL,Male,9503867878,A',
           '2220,BHUSNIKAR PARTH RAJKUMAR,Male,8149531947,A',
           '2221,BIRLE PRATIKSHA HANAMANT,Female,9146442441,A',
           '2222,PAWAR AKSHAY SHIVAJI,Male,9421360409,A',
           '2223,GAIKWAD VINAY BAJRANG,Male,8983839599,A',
           '2224,KALE BHUSHAN BAPUSAHEB,Male,9421355929,A',
           '2225,BURSE APEKSHA KAILAS,Female,7385650088,A',
           '2226,CHAPALE DIPALI NETAJI,Female,9975439339,A',
           '2227,CHAVAN RUTWIK VIJAY,Male,8605223836,A',
           '2228,CHAVAN SNEHA RAMESH,Female,9423074373,A',
           '2229,CHAVAN SONALI GOVIND,Female,8482929483,A',
           '2230,KAMTHANE SADHANA SANJEEV,Female,9881215998,A',
           '2231,DARADE PRATEEK MACHHINDRA,Male,9518522427,A',
           '2232,DARAK SAMIKSHA SANJAY,Female,9822139024,A',
           '2233,DAWALE SHRIKANT SUBHASH,Male,9689367173,A',
           '2235,DESHMANE MOHINEE HANUMNAT,Male,9637095153,A',
           '2236,DESHMANE PRIYANKA DATTATRAY,Female,9764255643,A',
           '2237,DESHMUKH RICHA BALASAHEB,Female,8830168920,A',
           '2238,BHOSALE PRAJAKTA RAJKUMAR,Female,9764600680,A',
           '2239,DEVGIRE ASHVINI DATTATRAY,Female,9403934151,A',
           '2240,DOIPHODE POONAM LAXMAN,Female,9764202134,A',
           '2241,DOSHI YASH ANIL,Male,9011403981,A',
           '2242,GAIKWAD RAKHI GOVIND,Female,9860157133,A',
           '2243,GAIKWAD SHRADDHA RAJABHAU,Female,8806665573,A',
           '2244,MUNDE SANDIP RAMAKANT,Male,9881208170,A',
           '2246,LONDHE ADITI BHAGWAT,Female,8975207251,A',
           '2247,GAVALI RADNYEE DIGAMBAR,Female,9923407007,A',
           '2248,GAVHANE ROHAN RAM,Male,9960125511,A',
           '2249,NANDGAVE KIRAN MAHADEV,Male,9545414401,A',
           '2250,GHODAKE PRIYANKA GANPATI,Female,9604142327,A',
           '2251,GHODKE ABHISHEK SUBHASH,Male,9637861016,A',
           '2252,GHODKE PRANAV NAVNATH,Female,9665923516,A',
           '2253,GHOGARE NAMRATA VISHWAJEET,Female,9421320007,A',
           '2254,GHORPADE PRAVIN BALASAHEB,Male,9552492320,A',
           '2256,GHUGE SNEHA ANIL,Female,7350296696,A',
           '2257,GIRI MANGESH UMESH,Male,9922668385,A',
           '2258,GONTE MAYURI RAJKUMAR ,Female,8975558422,A',
           '2260,GUNDIBONE MAYURI SUGRIV,Female,7038043647,A',
           '2261,GURAV PUJA SHRIRANG,Female,9604053290,A',
           '2262,GURME OMKAR BALAJI,Male,9503180513,A',
           '2263,HAJAGUDE SAYALI BABASAHEB,Female,9172245423,A',
           '2264,HANGARGE SWAPNAJA SHANKAR,Female,7798941032,A',
           '2266,CHIKHALE NEHA MURALIDHAR,Female,9921375471,A',
           '2267,KANTHE ANIKET ANKUSH,Male,8378083140,A',
           '2268,KALE NIKHIL NAGNATH,Male,8551915533,A',
           '2269,HOLKAR SNEHA SUNIL,Female,9552270068,A',
           '2270,KASAR SHAILESH DATTATRYA,Male,9623792630,A',
           '2271,KULKARNI VAISHNAVI SUDHAKAR,Female,9422161963,A',
           '2272,SARNIKAR BHAGYASHRI YUVARAJ,Female,9423345365,A',
           '2273,KAKADE HARSHALI VIPIN,Female,9422935209,A',
           '2274,MOHITE RUTUJA GULABRAO,Female,9850431016,A',
           '2275,JADHAV SNEHA MAHADEV,Female,9922037675,A',
           '2276,JADHAV SRUSHTI YUVRAJ,Female,9423992529,A',
           '2277,KADAM PRATIKSHA GOPAL,Female,9604025219,A',
           '2278,JAMADAR SNEHAL ABHIMANYU,Female,8421437747,A',
           '2280,JIDGE CHETANYA NAGNATH,Female,9850096178,A',
           '2281,JOSHI MUGDHA AVINASH,Female,9423720567,A',
           '2282,KALAM GANESH ASHOKRAO,Male,9850401749,A',
           '2283,KALETWAR SUPRITA SUBHASH,Female,9423437446,A',
           '2284,KALSHETTI POOJA MAHADEV,Female,9421355118,A',
           '2285,KAMBLE PRANIT APPASO,Male,9421100066,A',
           '2286,KAMBLE PRANJALI GORAKH,Female,8698550350,A',
           '2287,KAMBLE PRASENJIT KAMLAKAR,Male,9422720952,A',
           '2288,KAMBLE PRATIKHSA BALAJI,Female,9623639329,A',
           '2289,SALUNKE PRATHVIRAJ APPASAHEB,Male,9822737873,A',
           '2290,KAMBLE SMITANJALI NARAYAN,Female,9049303561,A',
           '2291,KANKAL SHRADDHA SANJAY,Female,7588332122,A',
           '2292,KANKURE PRADNYA GANGADHAR,Female,9421903480,A',
           '2293,KAPURE ANKITA UTTAM,Female,9320471000,A',
           '2294,KAREWAD ANURAG VINAYAK,Male,9960796039,A',
           '2297,KASBE APEKSHA SURYAKANT,Female,8275165010,A',
           '2298,KASHID PRANJALI RAMBHAU,Female,9423470908,A',
           '2299,KASHID SAKSHI ANNASAHEB,Female,9503242442,A',
           '2301,KATTE AJAY ANIL,Male,9960343716,A',
           '2304,KEVALRAM ADINATH KARTIKNATH,Male,9765623307,A',
           '2305,KHARBAD SWATIKA RAJABHAU,Female,9881647426,A',
           '2306,KHAROSE PRATIKSHA  MILIND,Female,9823294210,A',
           '2307,KHATALKAR SHREYA GANESH,Female,9421272245,A',
           '2308,KHEDE MAHADEV SANJAY,Male,7757086862,A',
           '2309,KHEDKAR RUTUJA SHIVAJI,Female,8421012344,A',
           '2311,KOKARE PANKAJ BALKRISHNA,Male,9423327528,A',
           '2312,KOLEKAR ANJALI AMBADAS,Female,9689414769,A',
           '2314,KSHIRSAGAR SANTOSH DADARAO,Male,9881568653,A',
           '2316,LAD SNEHAL SANTOSH,Female,7038120575,A',
           '2318,LAHANE PRATIKSHA SHIVDAS ,Female,8888813647,A',
           '2319,BHAGAT ONKAR CHANDRAKANT,Male,8308784260,A',
           '2320,RANKHAMB AISHWARYA VYANKAT,Female,9552210923,A',
           '2321,JADHAV ABHIJEET RAJENDRA,Male,8975492612,A',
           '2322,GORE DHANSHREE ARUN,Female,9422024547,A',
           '2323,SURVASE NILESH SHANKAR,Male,9764320831,A',
           '2324,SABDE ANKITA VINAYAK,Female,9763839724,A',
           '2325,LAMTURE SUCHITA BHAGWAN,Female,7387174414,A',
           '2326,UMAP CHAITANYA RAMESHWAR,Male,9011004302,A',
           '2327,SOLANKE RUTUJA GANESH,Female,9420022910,A',
           '2328,DALAWE NIKHIL TULSHIRAM,Male,9860054034,A',
           '2329,BIRADAR NIKITA SAHAJI,Female,9823186640,A',
           '2330,MULE SWAJIT MADHAVRAO,Male,9767706287,A',
           '2331,KHATKE SUKUMAR SATISH,Female,8625095138,A',
           '2332,MADIBONE PRATIKSHA BHAGWAT,Female,9689421778,A',
           '2333,MUNDE PRATIMA RAMRAO,Female,9403628365,A',
           '2335,JADHAV RUSHIKESH DINESH,Male,9604277941,A',
           '2339,PATHAK VAISHNAVI BALAJI,Female,9822734101,A',
           '2340,PATIL ADITI DHANANJAY,Female,9960690288,A',
           '2342,WAGHE MAHESH SURESH,Male,9850473509,A',
           '2343,GANGANE HARSHADA PARMESHWAR,Female,9552491511,A',
           '2344,SHAIKH SABER FARID,Male,9970463647,A',
           '2345,NAGALGAVE PRATIKSHA BASWARAJ,Female,9421450852,A',
           '2346,PANHALE TANUJA SANTOSH,Female,9921447572,A']

batch_A.each do |row|
  data = row.split(',')
  email = "#{data[0]}@se.com}"
  student = Student.find_or_initialize_by(email: email)
  student.roll_number = data[0]
  student.password = ('0'..'9').to_a.shuffle.first(6).join
  student.name = data[1]
  student.gender = data[2].downcase == 'male' ? 0 : 1
  student.parent_mobile = data[3] || ('0'..'9').to_a.shuffle.first(10).join
  student.save
  StudentBatch.create(student: student, batch: batch)
  puts "Adding student - #{email}"
end
