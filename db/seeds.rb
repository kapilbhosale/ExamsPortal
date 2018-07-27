# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#Create Batches
batch_list = ['XII - A 2019', '11th - A', '11th - D', 'NEET R-A']

batch_list.each do |name|
  Batch.create(name: name)
end

#Create Categories
category_list = ['Open', 'OBC', 'SC', 'ST', 'NT', 'VJNT']

category_list.each do |name|
  Category.find_or_create_by(name: name)
end
batch_ids = Batch.all.map(&:id)
#Create Students
students = [ {roll_number: 20112, name: 'Gore Vaishnavi Raju', mother_name: 'Sunita', date_of_birth: '2001-06-20', gender: 0, ssc_marks: 94.43, student_mobile: 9665311409, parent_mobile: 9595808999, address: 'Sharda Bhavan, Shyam Nagar, Nanded', college: 'Science Jr. College', category_id: 1},
           {roll_number: 20124, name: 'Sawant Omprakash Palaji', mother_name: 'Anuradha', date_of_birth: '2000-03-23', gender: 0, ssc_marks: 93.33, student_mobile: 9665311409, parent_mobile: 9423709872, address: 'Sharda Bhavan, Shyam Nagar, Nanded', college: 'Science Jr. College', category_id: 1},
           {roll_number: 20025, name: 'Rathod Akhil Prakash', mother_name: 'Jijabai', date_of_birth: '2001-08-02', gender: 0, ssc_marks: 90.43, student_mobile: 9665311409, parent_mobile: 9637903374, address: 'Sharda Bhavan, Shyam Nagar, Nanded', college: 'Science Jr. College', category_id: 1},
           {roll_number: 20098, name: 'Swami Aarati Balasaheb', mother_name: 'Gangasagar', date_of_birth: '2001-07-13', gender: 1, ssc_marks: 85.43, student_mobile: 9665311409, parent_mobile: 9923154812, address: 'Sharda Bhavan, Shyam Nagar, Nanded', college: 'Science Jr. College', category_id: 1},
           {roll_number: 20146, name: 'Jadhav Abhishek Vilasrao', mother_name: 'Munita', date_of_birth: '2001-09-10', gender: 0, ssc_marks: 82.43, student_mobile: 9665311409, parent_mobile: 9823859795, address: 'Sharda Bhavan, Shyam Nagar, Nanded', college: 'Science Jr. College', category_id: 1},
           {roll_number: 20087, name: 'Ramanwad Shrushti Ishwar', mother_name: 'Vandana', date_of_birth: '2001-03-19', gender: 1, ssc_marks: 77.43, student_mobile: 9665311409, parent_mobile: 9623914866, address: 'Sharda Bhavan, Shyam Nagar, Nanded', college: 'Science Jr. College', category_id: 1},
           {roll_number: 20094, name: 'Rode Shital Baswantrao', mother_name: 'Damyanti', date_of_birth: '2000-10-31', gender: 1, ssc_marks: 75.43, student_mobile: 9665311409, parent_mobile: 9423140351, address: 'Sharda Bhavan, Shyam Nagar, Nanded', college: 'Science Jr. College', category_id: 1}]
students.each do |student_hash|
  student = Student.new(student_hash)
  3.times do |i|
    student.student_batches.build(student_id: student.id, batch_id:batch_ids[i])
  end
  student.save!
end



practice_data = [
  {
    section: 'Diversity of Living Organisms',
    weitage: 14,
    topics: [
      'The Living World',
      'Biological Classification',
      'Plant Kingdom',
      'Animal Kingdom'
    ]
  },
  {
    section: 'Structural Organisation in Plants & Animals',
    weitage: 5,
    topics: [
      'Morphology of Flowering Plants',
      'Anatomy of Flowering Plants',
      'Structural Organisation in Animals'
    ]
  },
  {
    section: 'Cell: Structure and Function',
    weitage: 9,
    topics: [
      'Cell-The Unit of Life',
      'Biomolecules',
      'Cell Cycle and Cell Division'
    ]
  },
  {
    section: 'Plant Physiology',
    weitage: 6,
    topics: [
      'Transport in Plants',
      'Mineral Nutrition',
      'Photosynthesis in Higher Plants',
      'Respiration in Plants',
      'Plant - Growth and Development'
    ]
  },
  {
    section: 'Human Physiology',
    weitage: 20,
    topics: [
      'Digestion and Absorption',
      'Breating and Exchange of Gases',
      'Body Fluids and Circulation',
      'Excretory Products and Their Elimination',
      'Locomotion and Movement',
      'Neural Control and Coordination',
      'Chemical Coordination and Integration'
    ]
  },
  {
    section: 'Reproduction',
    weitage: 9,
    topics: [
      'Reproduction in Organisms',
      'Sexual Reproduction in Flowering Plants',
      'Human Reproduction',
      'Reproductive Health',
    ]
  },
  {
    section: 'Genetics and Evolution',
    weitage: 18,
    topics: [
      'Principles of Inheritance and Variation',
      'Molecular Basis of Inheritance',
      'Evolution',
    ]
  },
  {
    section: 'Biology and Human Welfare',
    weitage: 9,
    topics: [
      'Human Health and Diseases',
      'Strategies for Enhancement in Food Production',
      'Microbes in Human Welfare'
    ]
  },
  {
    section: 'Biotechnology and its Applications',
    weitage: 4,
    topics: [
      'Biotechnology - Principles and Processes',
      'Biotechnology and its Application'
    ]
  },
  {
    section: 'Ecology and Environment',
    weitage: 6,
    topics: [
      'Organisms and Populations',
      'Ecosystem',
      'Biodiversity and its Conservation',
      'Environmental Issues',
    ]
  }
]

subject = Subject.
