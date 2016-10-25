require 'test_helper'

class StarTestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
    @star_test = star_tests(:one)
    @first_student = students(:one)
    @second_student = students(:two)
    @new_star_test = {
      student: @first_student,
      test_date: Date.new(2016,10,5),
      scaled_score: 1,
      developmental_stage: 'MyString',
      alphabetic_principle: 1,
      concept_of_word: 1,
      visual_discrimination: 1,
      phonemic_awareness: 1,
      phonics: 1,
      structural_analysis: 1,
      vocabulary: 99,
      sentence_level_comprehension: 1,
      paragraph_level_comprehension: 1,
      early_numeracy: 94
    }
  end

  test "should be true" do 
    assert true 
  end 

  test "scaled score must be valid" do 
    star_test = StarTest.new(@new_star_test)
    wrong_scores = [-1, 100, 901, 1000]
    correct_scores = [300, 501, 900]
    wrong_scores.each do |wrong_score| 
      star_test.scaled_score = wrong_score
      assert star_test.invalid?
      assert_equal ["must be within 300 to 900"], star_test.errors[:scaled_score]
    end 
    correct_scores.each do |correct_score|
      star_test.scaled_score = correct_score
      assert star_test.valid?
    end 
    
  end 
end
