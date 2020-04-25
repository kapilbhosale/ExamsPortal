# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
# #
# # Examples:
# #
# #   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# #   Character.create(name: 'Luke', movie: movies.first)
# #Create Batches
# batch_list = ['12th JEE']

# batch_list.each do |name|
#   Batch.find_or_create_by(name: name)
# end unless Rails.env.production?

# #Create Categories
# category_list = ['Open', 'OBC', 'SC', 'ST', 'NT', 'VJNT']
category_list = ['Open', 'OBC', 'SC', 'ST', 'NT', 'VJNT']
category_list.each do |name|
  Category.find_or_create_by(name: name)
end

# practice_data = [
#   {
#     concept: 'Diversity of Living Organisms',
#     weitage: 14,
#     topics: [
#       'The Living World',
#       'Biological Classification',
#       'Plant Kingdom',
#       'Animal Kingdom'
#     ]
#   },
#   {
#     concept: 'Structural Organisation in Plants & Animals',
#     weitage: 5,
#     topics: [
#       'Morphology of Flowering Plants',
#       'Anatomy of Flowering Plants',
#       'Structural Organisation in Animals'
#     ]
#   },
#   {
#     concept: 'Cell: Structure and Function',
#     weitage: 9,
#     topics: [
#       'Cell-The Unit of Life',
#       'Biomolecules',
#       'Cell Cycle and Cell Division'
#     ]
#   },
#   {
#     concept: 'Plant Physiology',
#     weitage: 6,
#     topics: [
#       'Transport in Plants',
#       'Mineral Nutrition',
#       'Photosynthesis in Higher Plants',
#       'Respiration in Plants',
#       'Plant - Growth and Development'
#     ]
#   },
#   {
#     concept: 'Human Physiology',
#     weitage: 20,
#     topics: [
#       'Digestion and Absorption',
#       'Breating and Exchange of Gases',
#       'Body Fluids and Circulation',
#       'Excretory Products and Their Elimination',
#       'Locomotion and Movement',
#       'Neural Control and Coordination',
#       'Chemical Coordination and Integration'
#     ]
#   },
#   {
#     concept: 'Reproduction',
#     weitage: 9,
#     topics: [
#       'Reproduction in Organisms',
#       'Sexual Reproduction in Flowering Plants',
#       'Human Reproduction',
#       'Reproductive Health',
#     ]
#   },
#   {
#     concept: 'Genetics and Evolution',
#     weitage: 18,
#     topics: [
#       'Principles of Inheritance and Variation',
#       'Molecular Basis of Inheritance',
#       'Evolution',
#     ]
#   },
#   {
#     concept: 'Biology and Human Welfare',
#     weitage: 9,
#     topics: [
#       'Human Health and Diseases',
#       'Strategies for Enhancement in Food Production',
#       'Microbes in Human Welfare'
#     ]
#   },
#   {
#     concept: 'Biotechnology and its Applications',
#     weitage: 4,
#     topics: [
#       'Biotechnology - Principles and Processes',
#       'Biotechnology and its Application'
#     ]
#   },
#   {
#     concept: 'Ecology and Environment',
#     weitage: 6,
#     topics: [
#       'Organisms and Populations',
#       'Ecosystem',
#       'Biodiversity and its Conservation',
#       'Environmental Issues',
#     ]
#   }
# ]

# subject = Subject.find_or_create_by(name: 'Biology')
# practice_data.each do |concept_data|
#   concept = Concept.find_or_create_by(subject: subject, name: concept_data[:concept], weightage: concept_data[:weitage])
#   concept_data[:topics].each do |topic|
#     Topic.find_or_create_by(concept: concept, name: topic)
#   end
# end


exam_concepts = %w[general physics chemistry maths biology]
exam_concepts.each do |exam_concept|
  Section.find_or_create_by(name: exam_concept, is_jee: true)
end

# jee_sections = {
#   "phy-I" => "This section contains SIX (06) questions. 
#   Each question has FOUR options for correct answer(s). 
#   ONE OR MORE THAN ONE of these four option(s) is (are) correct option(s).",
#   "phy-II" => "This section contains EIGHT (08) questions. The answer to each question is a NUMERICAL VALUE.",
#   "phy-III" => "This section contains FOUR (04) questions.
#   Each question has TWO (02) matching lists: LIST‐I and LIST‐II.
#   FOUR options are given representing matching of elements from LIST‐I and LIST‐II. ONLY ONE of
#   these four options corresponds to a correct matching.",

#   "chem-I" => "This section contains SIX (06) questions. 
#   Each question has FOUR options for correct answer(s). 
#   ONE OR MORE THAN ONE of these four option(s) is (are) correct option(s).",
#   "chem-II" => "This section contains EIGHT (08) questions. The answer to each question is a NUMERICAL VALUE.",
#   "chem-III" => "This section contains FOUR (04) questions.
#   Each question has TWO (02) matching lists: LIST‐I and LIST‐II.
#   FOUR options are given representing matching of elements from LIST‐I and LIST‐II. ONLY ONE of
#   these four options corresponds to a correct matching.",

#   "math-I" => "This section contains SIX (06) questions. 
#   Each question has FOUR options for correct answer(s). 
#   ONE OR MORE THAN ONE of these four option(s) is (are) correct option(s).",
#   "math-II" => "This section contains EIGHT (08) questions. The answer to each question is a NUMERICAL VALUE.",
#   "math-III" => "This section contains FOUR (04) questions.
#   Each question has TWO (02) matching lists: LIST‐I and LIST‐II.
#   FOUR options are given representing matching of elements from LIST‐I and LIST‐II. ONLY ONE of
#   these four options corresponds to a correct matching.",
# }
# jee_sections.each do |name, description|
#   Section.find_or_create_by(name: name, description: description, is_jee: true)
# end

# unless Rails.env.production?
#   # Admin.find_or_create_by(email: 'admin@smartexams.com', password: 'p@ssword')
# end


Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each { |seed| load seed }
