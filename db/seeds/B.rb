batch = Batch.find_or_create_by(name: 'B')
batch_B = [
  '2352,LATIBE SANKET SUBHASH,Male,9637937685,B',
'2353,LOKHANDE RUTUJA SANTOSH,Female,9168034470,B',
'2354,LOMTE BHAGYASHRI RANGRATH,Female,9921867345,B',
'2355,NIMBALKAR SHRIYASH RAJU,Male,9422657214,B',
'2356,KOLHAL SHRADDHA BALAJI,Female,9822862204,B',
'2357,MALI SAURABH SHRIMANT,Male,7218277387,B',
'2358,BALAI KUNAL SANJAY,Male,9423718778,B',
'2359,MANE PRABUDDH SHAM ,Male,7030146358,B',
'2360,MANE RAJ SHAHAJI,Male,9421953267,B',
'2361,MANE SAYALI SANJAY,Female,7558528087,B',
'2362,MANE SNEHA ARVIND,Female,9403101003,B',
'2363,MANE SNEHAL DAYANAND ,Male,9561261625,B',
'2364,MARE SOMESH AMAR,Male,7588389420,B',
'2365,MARKANTE VINAYA SADANAND,Female,9423437555,B',
'2366,MASKE SHARDDHA KESHAV,Female,9403937690,B',
'2367,MHETRE MUKUND BALAJI,Male,9975821467,B',
'2368,MORE SAMBHAJI SANJAY,Male,9689074474,B',
'2369,MORE GAURI GUNDAJIBAPU,Female,9860910465,B',
'2370,MORE RUTURAJ SURESH,Male,9404026371,B',
'2375,NAGTILAK ADITYA NARAYAN,Male,9403640835,B',
'2378,NEWALE ANKITA BALIRAM,Female,7756052720,B',
'2381,NIRPHAL AMISHA RAM,Female,9881256235,B',
'2382,PADWAL MAYURI HANAMANT,Male,9881234383,B',
'2384,PARGE RUTUJA RAVINDRA,Female,9527554205,B',
'2386,PATIL AISHWARYA RAMCHANDRA,Female,9822785351,B',
'2387,PATIL AKHILESH PRAMOD,Male,9822323740,B',
'2389,PATIL MADHURA RAMRAO,Female,9421843417,B',
'2390,PAWAR ADITYA RAJKUMAR,Male,9860149527,B',
'2391,PAWAR APARNA SANJAY,Female,9975534117,B',
'2392,PAWAR RUTUJA VIJAYKUMAR,Female,9404855018,B',
'2394,PHAD JYOTI VENKATI,Female,9822016937,B',
'2395,PHUTANE SNEHAL DEEPAK,Female,9860687558,B',
'2397,RATHOD ASHISH BANDU,Male,9420874115,B',
'2398,RATHOD DIPTI MAHADEV,Female,9423766077,B',
'2399,RATHOD MAYUR BABRUWAN,Male,8308896141,B',
'2400,RATHOD SATYAM VASANT,Male,9404257937,B',
'2401,RATHOD VAISHNAVI SOPAN,Female,9421094885,B',
'2402,RAUT SURAJ PANDURANG,Male,9158461346,B',
'2403,RAVANGAVE VAIBHAV MADHAV,Male,9403003223,B',
'2404,REDDY KSHITIJA SANJAY,Female,8484097159,B',
'2405,RODE SURAJ SUBHASH,Male,9096079651,B',
'2406,ROHINE SWATI SURESH,Female,9860276143,B',
'2408,SALUNKE PRAJAKTA PRABHAKAR,Female,9960660856,B',
'2409,SALUNKE SAGAR DAYANAND,Male,9011673135,B',
'2410,SALUNKE SAYALI SHIVAJI,Female,9158190079,B',
'2411,SALUNKE SHRIKRISHNA MADHUKAR,Male,7218978061,B',
'2412,SALVE SAMRUDDHI SHANKRRAO,Female,9421866903,B',
'2414,SARANG AKASH MAHADEV,Male,9096301931,B',
'2417,DOIFODE PRAKASH GORAKHANATH,Male,9421350631,B',
'2420,SHELKE SHRADHA SANJAY,Female,9881052447,B',
'2421,SHENDE SAGAR SUBHASH,Female,9420020449,B',
'2422,SHEP MAHESH SURYAKANT,Male,9922680917,B',
'2423,SHERE PRYANKA BHANUDAS,Female,9890564681,B',
'2425,SHINDHIKUMTE RUSHIKESH RAJKUMAR,Male,9881520170,B',
'2426,SHIRAL PRITI GAJENDRA,Female,8862044286,B',
'2427,SHIRURE NIVEDITA MAHARUDRA,Female,8007374755,B',
'2430,SONKAMBLE PALLAVI SIDDHRATH,Female,9421485993,B',
'2432,SONWANE PRADNYA SURYABHAN,Female,9270801112,B',
'2433,SONWANE VAISHNAVI PRADEEP,Female,9960012360,B',
'2434,SURWASE AJAY SANTRAM,Male,9850174275,B',
'2435,SURWASE RUTUJA MILIND,Female,8605146653,B',
'2436,SURWASE SACHIN JOTIRAM,Male,9850174275,B',
'2437,SURYAWANSHI SHRADDHA JITENDRA,Female,8600034888,B',
'2438,TALKE KSHITIJ UTTAM,Male,8379999515,B',
'2439,TALKE PRAVIN ASHRUBA,Male,7350183165,B',
'2441,TAMBOLI SABIYA SHAKIL,Male,7350660888,B',
'2442,TAMBOLI UMME ROMAN WAJEED,Female,9765123004,B',
'2443,TARATE OMPRASAD VASISHTHA,Male,9421339849,B',
'2444,TELI AKSHATA RAJENDRA,Female,8275487701,B',
'2446,TODKAR PRACHI BHANUDAS,Female,9822210320,B',
'2447,TONDARE SNEHA SHIVLING,Female,7798967212,B',
'2448,VASEKAR PRAJKTA BALASAHEB,Female,9923143933,B',
'2449,VEER DIVYA ARUN,Female,9850090942,B',
'2450,VEER SAKSHI SHANTILAL,Female,8600737680,B',
'2451,WAGH SUSHMA GOVIND,Female,9975279675,B',
'2453,WAYACHALE ABOLI LAXMAN,Female,9860589907,B',
'2455,ZADE RUSHIKESH BALKRISHNA,Male,9422935208,B',
'2456,ZARGER FAIZAN ZAKER,Male,8600385076,B',
'2457,ZIKRE ASMA ZAFAR,Female,9175455782,B',
'2460,POLAWAR PRANITA SHIRISH,Female,9403526721,B',
'2462,HUDE DIVYA NANASAHEB,Female,9420212490,B',
'2463,SALVE ROHIT PRAMOD ,Male,9552072358,B',
'2464,MOTHE VAISHNAVI LAXMAN,Female,9822545728,B',
'2467,GADHAVE KANAK KALPAK,Male,7972106370,B',
'2468,HASHMI UBAID SAJID,Male,9860894870,B',
'2469,KORE VAIBHAV BHARAT,Male,9623080393,B',
'2470,BORSURE HARSHVARDHAN DATTATRAYA,Male,9421516652,B',
'2471,SOMUSE SHUBHAM SUBHASHCHANDRA,,8830473295,B',
'2472,KENDRE SHRIKANT SHIVAJI,,9421693975,B',
'2473,QUREZHI AAWEZ MUSTAFA,Male,9822932911,B',
'2474,HANDIBAG PRATIK APPASAHEB,,9422592555,B',
'2475,MANDODE VAIBHAVI RAMESHWAR,Female,9823795946,B',
'2476,DOKE GAYATRI AMARESHWAR,Female,9420326174,B',
'2477,KAMBLE SWAPNIL BHAGWAT,Male,9552631755,B',
'2478,VYAVAHARE SHREYAS DHANAJI,Male,9273419514,B',
'2479,DHUMAL SAIRAJ LIMBRAJ,Male,9689291529,B',
'2480,PATIL SAKSHI ABASAHEB,Female,9552410506,B',
'2481,KENDRE VAISHNAVI UTTAM,Female,8605757664,B',
'2482,FUTANE BHAKTI PRAKASH,Female,9960094107,B',
'2483,MUCHATE AKSHAY GIRJAPPA,Male,9421362933,B',
'2484,KALE MAYURI BAPURAO,Female,7775896922,B',
'2485,KARPE DHANASHRI MAHADEV,Female,9881982184,B',
'2486,GURME ROHIT MADHAV,,9552466430,B',
'2487,MARE SHRIDHAR MADHAV,,9657338520,B',
'2488,DOKDE ABHISHEK SHASHIKANT,,9604085719,B',
'2489,SINGARE ADINATH PANDHARINATH,Male,7776052107,B',
'2490,HILLAL GAYATRI VIJAYKUMAR,Female,9404276090,B',
'2491,KADAM SUMIT SATISH,Male,7385565709,B',
'2492,TEKALE RUTUJA BHARAT,Female,9923902498,B',
'2493,SHINDE SNEHA GOVIND,Female,8275454110,B',
'2494,KAUSHIK PRATIK ARVINDRAO,Male,9421365473,B',
'2495,BAGWAN SHOAEB NAZIR,Male,8180957268,B',
'2496,DALAL PRASAD SANTOSH,Male,9421372379,B',
'2497,MHETRE ANJALI VINOD,Female,9923736113,B',
'2498,NANAWARE RUTUJA SATYAVAN,Female,9975358925,B',
'2499,NAGRGORJE VAISHNAVI GANPAT,Female,9403540056,B',
'2500,GOMCHALE PADMJA GANGADHAR,Female,9823012792,B'
]

batch_B.each do |row|
  data = row.split(',')
  email = "#{data[0]}@se.com"
  student = Student.find_or_initialize_by(email: email)
  student.roll_number = data[0]
  rand_password = ('0'..'9').to_a.shuffle.first(6).join
  student.password = rand_password
  student.raw_password = rand_password
  student.name = data[1]
  student.gender = data[2].downcase == 'male' ? 0 : 1
  student.parent_mobile = data[3] || ('0'..'9').to_a.shuffle.first(10).join
  student.save
  StudentBatch.create(student: student, batch: batch)
  puts "Adding student - #{email}"
end
