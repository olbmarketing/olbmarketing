# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

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