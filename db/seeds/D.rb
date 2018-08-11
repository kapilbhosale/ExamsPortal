batch = Batch.find_or_create_by(name: 'D')
batch_D = [
  '2651,KESGIRE ANUJA ARUN,Female,9420073243,D',
  '2653,KHOJE VAISHANAVI HANUMANT,Female,9421346105,D',
  '2654,KHULGE RENUKA DAMODAR,Female,9730654165,D',
  '2656,KOMBADE ROHAN RAM,Male,9822627333,D',
  '2658,KULKARNI MAHESH SATISHRAO,Female,9975439345,D',
  '2659,KULKARNI VAISHNAVI DIPAKRAO,Female,7798164953,D',
  '2660,KUMBHAR PRAJAKTA TANAJI,Female,9834296026,D',
  '2661,KUMBHAR SAKSHI BHASKAR,Female,9096529091,D',
  '2663,KUTE ADITYA BALASAHEB,Male,8888343491,D',
  '2667,MALI  ADITYA HARIRAM,Male,9860514057,D',
  '2670,MANE PRITEE VIKAS,Female,9975807544,D',
  '2671,MANE RAHUL SHIVAJIRAO,Male,9405158666,D',
  '2672,MASKE ANJALI WALMIK,Female,7770037622,D',
  '2673,MASKE SNEHA DATTATRYA,Female,9422639880,D',
  '2674,MHETRE SUSHIL UTTAM,Male,9421091659,D',
  '2675,MOHAMMED INZIMAM UL HAQ IKARM UL HAQ,Male,9096736637,D',
  '2678,MORE PRATIKSHA LAXMAN,Male,9822840222,D',
  '2679,MORE VAISHNAVI SAHEBRAO,Female,9604889229,D',
  '2681,SHETE ISHWAR SUDHIR,Male,9890596656,D',
  '2682,MUNDHE POONAM ASHOK ,Female,9623757502,D',
  '2684,NAGARGOJE MAYURI MARUTI,Female,9036352394,D',
  '2685,NANDGURE POOJA GYANBA,Female,8381067470,D',
  '2687,NARWATE SHOBHA SAMBHJI,Female,9420872194,D',
  '2690,OVHAL RUTUJA SURESH,Female,9689848970,D',
  '2691,PANCHAL ANANDI SATISH,Female,9421372683,D',
  '2692,PANCHAL NIKATA MADHUKAR,Female,9423818599,D',
  '2693,PANDHARE DIGVIJAY SURESH,Male,9822511800,D',
  '2695,PATIL PUSHKAR ABHIJEET,Male,9422068683,D',
  '2696,PATIL SANDIP SHIVARAJ,Male,9921595370,D',
  '2698,PHAD DARSHAN RAMKRUSHAN,Male,7350166247,D',
  '2699,PHARTALE VISHAL NANDKUMAR,Male,9175316173,D',
  '2704,PUNDKARE VAISHNAVI PANDURANG,Female,9657675351,D',
  '2705,RAJGIRWAD SHUBHAM BABURAO,Male,9420215060,D',
  '2706,RAJHANS RUSHIKESH ANIL,Male,9850311044,D',
  '2709,RATHOD RAHUL RAMESH,Male,7588178272,D',
  '2710,RICHPURE AKANKSHA SATISH,Female,9623412821,D',
  '2718,SAYYAD MUSKAN IBRAHIM,Female,708917864,D',
  '2719,SHAIKH ARBAJ AKBAR,Male,8275452881,D',
  '2720,SHAIKH FAIZUL HASSAN KHAMAR,Male,9822868842,D',
  '2722,SHAIKH OMAR RAJA,Male,9892336276,D',
  '2724,SHAIKH SHAGUFTA SALIM,Female,9175090760,D',
  '2727,SHELKE VAISHNAVI JITENDRA,Female,9922915742,D',
  '2729,SHINDE ANISHA ABASAHEB,Female,9552069151,D',
  '2730,MURUMKAR SURAJ ASHOK,Male,9665034038,D',
  '2732,SHIVANKAR NAMRATA BABASAHEB,Female,9422639935,D',
  '2735,SOMVANSHI HARSHVARDHAN KAMLAKAR,Male,9823253842,D',
  '2736,SONTAKKE AMIT MURLIDHAR ,Male,9823535043,D',
  '2737,SURWASE KIRAN KACHARU,Female,9763615600,D',
  '2738,SURWASE MRUNAL GAJENDRA,Female,9850796081,D',
  '2741,SURYAWANSHI SANDEEP BALAJI,Male,9011703504,D',
  '2742,SUWARNAKAR MAHESHWARI RANJEET,Female,7249457074,D',
  '2743,SWAMI PRATHAMESH NAGNATH,Male,9604307568,D',
  '2744,SWAMI PRATIKSHA MAHADEV,Female,9420216703,D',
  '2745,SWAMI VAISHNAVI SURESH,Female,9860244374,D',
  '2748,TAMBOLI SHAISTANAAZ YUNUS,Female,9665227300,D',
  '2749,TAMBOLI SIMRAN ABDUL AZIZ,Female,9421450930,D',
  '2750,TAPDIYA SHREYAS RAMESHWAR,Male,9423732067,D',
  '2751,TONDARE SAMPADA SANDIP,Female,9823659405,D',
  '2752,TONDARE YOGITA DEEPAK,Female,8390304200,D',
  '2754,TRIPATI PALLAVI DNYANESHWAR,Female,9764799074,D',
  '2756,WADKAR GANESH SANJAY,Male,9527875857,D',
  '2757,WAGHMARE SAKSHI PRAKASH,Female,9923914087,D',
  '2759,WANGWAD ANKITA NAMDEV,Female,9764732518,D',
  '2760,WANTEKAR OMKAR RAJKUMAR,Male,9175546040,D',
  '2761,YADAV AKSHAY BLASAHEB,Male,9767568595,D',
  '2762,YADAV YASHVAROHAN PRAMOD,Male,9922604181,D',
  '2764,ZANWAR KIRTI MADANLAL,Female,9511652084,D',
  '2768,MANE GARGI PANDIT,Female,9763501015,D',
  '2769,SHAIKH ARBAZ ZUBER,Male,8625976225,D',
  '2771,SHINDE ADITI SHARADRAO,Female,9421372003,D',
  '2772,INGAWALE GAYATRI SHASHIKANT,Female,9921614782,D',
  '2773,DIGHE PRAJKTA TUKARAM,Female,9766383392,D',
  '2774,KARNAWAT RIYA SUNIL,Female,9403727539,D',
  '2775,KAMBLE MAYURI MILIND,Female,8605064091,D',
  '2776,DOSHI SONIR NILESH,Male,9422066463,D',
  '2778,VORA SONIYA MANISH,Female,9890001315,D',
  '2779,LOMATE SWAPNIL PRAFULL,Male,8412874653,D',
  '2780,SAVATKAR SHRILEKHA LAXMAN,Female,9423436811,D',
  '2781,BHUJABAL SHWETA MACHINDRA,Female,9112684097,D',
  '2782,ALLISHE SURAJ SHRISHAIL,Male,9764578194,D',
  '2783,PATIL PRAJWAL BHASKARRAO,Male,9404273435,D',
  '2784,BULBULE VAISHNAVI NANDKISHOR,Female,9422901897,D',
  '2786,SHAIKH MOHID SAJID,Male,9767845355,D',
  '2787,BIDVE ANIL SANJAY,,9850994689,D',
  '2788,ANDHARE DNYANESHWARI RAMAKANT,Female,9561918219,D',
  '2789,WARAD ISHWARI ASHOK,Female,9421447900,D',
  '2790,PATIL VAISHANAVI VIKAS,Female,8446243004,D',
  '2791,WAGHMARE HARSHADA DEVIDAS,Female,9673918865,D',
  '2792,KULKARNI SAMRUDDHI NANDKUMAR,Female,8412850011,D',
  '2793,KUTWADE PALLAVI BALAJI,Female,9422757733,D',
  '2794,AUTE YASWANT RAMDHAN,Male,9921255955,D',
  '2795,JADHAV PRATHMESH RAMESH,Male,9561796376,D',
  '2796,KUDALE SANKET SHAM,Male,9689965601,D'
]

batch_D.each do |row|
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
