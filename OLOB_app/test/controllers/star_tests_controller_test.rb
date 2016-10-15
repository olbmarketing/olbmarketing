require 'test_helper'

class StarTestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @star_test = star_tests(:one)
    @first_student = students(:one)
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

  test "should get index" do
    
    get star_tests_url(student_id: @first_student.id)
    assert_response :success
  end

  test "should get new" do
    get new_star_test_url(student_id: @first_student.id)
    assert_response :success
  end

  test "should create star_test" do
    assert_difference('StarTest.count') do
      post star_tests_url, params: { star_test: { alphabetic_principle: @star_test.alphabetic_principle, concept_of_word: @star_test.concept_of_word, developmental_stage: @star_test.developmental_stage, paragraph_level_comprehension: @star_test.paragraph_level_comprehension, phonemic_awareness: @star_test.phonemic_awareness, phonics: @star_test.phonics, scaled_score: @star_test.scaled_score, sentence_level_comprehension: @star_test.sentence_level_comprehension, structural_analysis: @star_test.structural_analysis, student_id: @star_test.student.id, test_date: @star_test.test_date, visual_discrimination: @star_test.visual_discrimination, vocabulary: @star_test.vocabulary, early_numeracy: @star_test.early_numeracy } }
    end

    assert_redirected_to star_test_url(StarTest.last)
  end

  test "should show star_test" do
    get star_test_url(@star_test)
    assert_response :success
  end

  test "should get edit" do
    get edit_star_test_url(@star_test)
    assert_response :success
  end

  test "should update star_test" do
    # initial vocabulary is 1
    assert_equal(@star_test.vocabulary, 1)
    # update the vocabulary to be 99
    patch star_test_url(@star_test), params: { star_test: @new_star_test }
    assert_redirected_to star_test_url(@star_test)
    get star_test_url(@star_test) + '.json'
    assert_equal JSON.parse(response.body)['vocabulary'], 99, "after update the vocabulary should be 99"
  end

  test "should destroy star_test" do
    assert_difference('StarTest.count', -1) do
      delete star_test_url(@star_test)
    end

    assert_redirected_to star_tests_url(student_id: @star_test.student.id)
  end

  test "should get students" do 
    get star_tests_students_url(student_id: @first_student.id)
    assert_response :success
  end 
  
end
