# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#seed parishes
Parish.delete_all

Parish.create(name: "St. Brendan",
  phone: "1234567890",
  address: "4475 Dublin Road",
  city: "Columbus",
  state: "OH",
  zip: "43026")

# seed students
Student.delete_all
Student.create!(school_year: '2016-17',new_or_return: 'New',student_class: 'PS',last_name: 'Alo',first_name: 'Ella',father_name: 'Michael',mother_name: 'Elizabeth',address: '1488 Candlewood Drive',city: 'Columbus',state: 'OH',zip: '43235',email1: 'not listed',email2: 'elizabeth@vitalwork.com',catholic: 'Y',parish: 'St. Michael',race: 'White/Caucasian',resides_with: 'Both',reference_from: 'Social Media - Internet')
Student.create!(school_year: '2013-14',new_or_return: '',student_class: 'PS',last_name: 'Alo',first_name: 'Janie',father_name: 'Michael',mother_name: 'Elizabeth',address: '',city: '',state: '',zip: '',email1: 'not listed',email2: 'elizabeth@vitalwork.com',catholic: '',parish: '',race: '',resides_with: '',reference_from: '')
Student.create!(school_year: '2015-16',new_or_return: 'Return',student_class: 'AMPreK',last_name: 'Bakhshi',first_name: 'Juliet',father_name: 'Aaron',mother_name: 'Susan',address: '58 West Riverglen Drive',city: 'Worthington',state: 'OH',zip: '43085',email1: 'aaron@burkeproducts.com',email2: 'suzg8@hotmail.com',catholic: 'Y',parish: 'St. Michael',race: 'White/Caucasian',resides_with: 'Both',reference_from: 'Current / Alumni Family')
Student.create!(school_year: '2016-17',new_or_return: 'New',student_class: 'PMPreK',last_name: 'Barrington',first_name: 'Agnes',father_name: 'Don',mother_name: 'Molly',address: '2708 Mornt Holyoke Road',city: 'Columbus',state: 'OH',zip: '43221',email1: 'dlbarrington2@yahoo.com',email2: 'mollybarrington1@gmail.com',catholic: 'Y',parish: 'St. Agatha',race: 'White/Caucasian',resides_with: 'Both',reference_from: 'Referred by Current / Alumni Family')
Student.create!(school_year: '2015-16',new_or_return: 'Return',student_class: 'K',last_name: 'Benvenuti',first_name: 'Nathan',father_name: 'Bob',mother_name: 'Nikki',address: '6963 Ballantrae Loop',city: 'Dublin',state: 'OH',zip: '43016',email1: 'benvenub@synthes.com',email2: 'nikki_bester@hotmail.com',catholic: 'N',parish: 'NA',race: 'White/Caucasian',resides_with: 'Both',reference_from: 'Current / Alumni Family')
Student.create!(school_year: '2016-17',new_or_return: 'New',student_class: 'PS',last_name: 'Bond',first_name: 'Anna',father_name: 'Matt',mother_name: 'Megan',address: '6976 Constitution Place ',city: 'Columbus',state: 'OH',zip: '43235',email1: 'bond.106@gmail.com',email2: 'brown.2223@gmail.com',catholic: 'N',parish: 'NA',race: 'White/Caucasian',resides_with: 'Both',reference_from: 'Referred by Current / Alumni Family')
Student.create!(school_year: '2015-16',new_or_return: 'Return',student_class: 'AMPreK',last_name: 'Brehm',first_name: 'Emily',father_name: 'Michael',mother_name: 'Andrea',address: '107 West Cooke Road',city: 'Columbus',state: 'OH',zip: '43214',email1: 'mbrehm6@yahoo.com',email2: 'andrea_dejohn@att.net',catholic: 'Y',parish: 'OLP',race: 'White/Caucasian',resides_with: 'Both',reference_from: 'Current / Alumni Family')
Student.create!(school_year: '2013-14',new_or_return: 'Return',student_class: 'AMPreK',last_name: 'Brown',first_name: 'Sophia',father_name: 'Sunny',mother_name: 'Megan',address: '255 Blenheim Road',city: 'Columbus',state: 'OH',zip: '43214',email1: 'sbrown@skurnikwines.com',email2: 'megmc75@hotmail.com',catholic: 'Y',parish: 'St. Andrew',race: 'White/Caucasian',resides_with: 'Both',reference_from: 'Current / Alumni Family')
Student.create!(school_year: '2016-17',
  new_or_return: '',
  student_class: 'TTT',
  last_name: 'Brown',
  first_name: 'Carter',
  father_name: 'Sunny',
  mother_name: 'Megan',
  address: '',
  city: '',
  state: '',
  zip: '',
  email1: 'sbrown@skurnikwines.com',
  email2: 'megmc75@hotmail.com',
  catholic: '',
  parish: '',
  race: '',
  resides_with: '',
  reference_from: '')
Student.create!(school_year: '2016-17',
  new_or_return: 'New',
  student_class: 'PMPreK',
  last_name: 'Burgess',
  first_name: 'Mary-Maginn',
  father_name: 'Joseph',
  mother_name: 'Jennifer',
  address: '249 East Kelso Road ',
  city: 'Columbus',
  state: 'OH',
  zip: '43202',
  email1: 'joeburgess3@gmail.com',
  email2: 'jcburgess25@gmail.com',
  catholic: 'Y',
  parish: 'Immaculate Conception',
  race: 'White/Caucasian',
  resides_with: 'Both',
  reference_from: 'Current / Alumni Family')

# seed star test data
StarTest.delete_all

StarTest.create!(
  student: Student.all.first,
  test_date: Date.new(2015,11,20),
  scaled_score: 781,
  developmental_stage: 'Emergent Reader Stage',
  alphabetic_principle: 93,
  concept_of_word: 94,
  visual_discrimination: 96,
  phonemic_awareness: 81,
  phonics: 81,
  structural_analysis: 76,
  vocabulary: 81,
  sentence_level_comprehension: 79,
  paragraph_level_comprehension: 74,
  early_numeracy: 92
)

StarTest.create!(
  student: Student.all.first,
  test_date: Date.new(2016,01,14),
  scaled_score: 781,
  developmental_stage: 'Emergent Reader Stage',
  alphabetic_principle: 81,
  concept_of_word: 82,
  visual_discrimination: 88,
  phonemic_awareness: 60,
  phonics: 58,
  structural_analysis: 50,
  vocabulary: 60,
  sentence_level_comprehension: 53,
  paragraph_level_comprehension: 49,
  early_numeracy: 79
)

StarTest.create!(
  student: Student.all.first,
  test_date: Date.new(2016,4,5),
  scaled_score: 781,
  developmental_stage: 'Emergent Reader Stage',
  alphabetic_principle: 75,
  concept_of_word: 77,
  visual_discrimination: 84,
  phonemic_awareness: 52,
  phonics: 50,
  structural_analysis: 42,
  vocabulary: 53,
  sentence_level_comprehension: 45,
  paragraph_level_comprehension: 41,
  early_numeracy: 73
)

StarTest.create!(
  student: Student.all.first,
  test_date: Date.new(2016,5,12),
  scaled_score: 781,
  developmental_stage: 'Emergent Reader Stage',
  alphabetic_principle: 94,
  concept_of_word: 95,
  visual_discrimination: 97,
  phonemic_awareness: 84,
  phonics: 84,
  structural_analysis: 79,
  vocabulary: 84,
  sentence_level_comprehension: 82,
  paragraph_level_comprehension: 78,
  early_numeracy: 94
)
