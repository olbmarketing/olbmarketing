require 'test_helper'

class StarTestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @star_test = star_tests(:one)
  end

  test "should get index" do
    get star_tests_url
    assert_response :success
  end

  test "should get new" do
    get new_star_test_url
    assert_response :success
  end

  test "should create star_test" do
    assert_difference('StarTest.count') do
      post star_tests_url, params: { star_test: { alphabetic_principle: @star_test.alphabetic_principle, concept_of_word: @star_test.concept_of_word, developmental_stage: @star_test.developmental_stage, paragraph_level_comprehension: @star_test.paragraph_level_comprehension, phonemic_awareness: @star_test.phonemic_awareness, phonics: @star_test.phonics, scaled_score: @star_test.scaled_score, sentence_level_comprehension: @star_test.sentence_level_comprehension, structural_analysis: @star_test.structural_analysis, student_id: @star_test.student_id, test_date: @star_test.test_date, visual_discrimination: @star_test.visual_discrimination, vocabulary: @star_test.vocabulary } }
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
    patch star_test_url(@star_test), params: { star_test: { alphabetic_principle: @star_test.alphabetic_principle, concept_of_word: @star_test.concept_of_word, developmental_stage: @star_test.developmental_stage, paragraph_level_comprehension: @star_test.paragraph_level_comprehension, phonemic_awareness: @star_test.phonemic_awareness, phonics: @star_test.phonics, scaled_score: @star_test.scaled_score, sentence_level_comprehension: @star_test.sentence_level_comprehension, structural_analysis: @star_test.structural_analysis, student_id: @star_test.student_id, test_date: @star_test.test_date, visual_discrimination: @star_test.visual_discrimination, vocabulary: @star_test.vocabulary } }
    assert_redirected_to star_test_url(@star_test)
  end

  test "should destroy star_test" do
    assert_difference('StarTest.count', -1) do
      delete star_test_url(@star_test)
    end

    assert_redirected_to star_tests_url
  end
end
