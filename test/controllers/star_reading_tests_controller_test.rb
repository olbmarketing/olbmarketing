require 'test_helper'

class StarReadingTestsControllerTest < ActionDispatch::IntegrationTest
  fixtures :users
  setup do
    @star_reading_test = star_reading_tests(:one)
    @first_student = students(:one)
    @second_student = students(:two)
    login_setup
  end

  test "should get index" do
    get star_reading_tests_url(student_id: @first_student.id)
    assert_response :success
  end

  test "should get new" do
    get new_star_reading_test_url(student_id: @first_student.id)
    assert_response :success
  end

  test "should create star_reading_test" do
    assert_difference('StarReadingTest.count') do
      post star_reading_tests_url, params: { 
        star_reading_test: { 
          informational_text_key_ideas_and_details: @star_reading_test.informational_text_key_ideas_and_details, 
          language_vocabulary_acquisition_and_use: @star_reading_test.language_vocabulary_acquisition_and_use, 
          literature_craft_and_structure: @star_reading_test.literature_craft_and_structure, 
          literature_key_ideas_and_details: @star_reading_test.literature_key_ideas_and_details, 
          percentile_rank: @star_reading_test.percentile_rank, 
          scaled_score: @star_reading_test.scaled_score, 
          student_id: @star_reading_test.student_id, 
          test_date: @star_reading_test.test_date 
        } 
      }
    end

    assert_redirected_to star_reading_tests_url(student_id: @star_reading_test.student_id)
  end

  test "should show star_reading_test" do
    get star_reading_test_url(@star_reading_test)
    assert_response :success
  end

  test "should get edit" do
    get edit_star_reading_test_url(@star_reading_test)
    assert_response :success
  end

  test "should update star_reading_test" do
    patch star_reading_test_url(@star_reading_test), params: { star_reading_test: { informational_text_key_ideas_and_details: @star_reading_test.informational_text_key_ideas_and_details, language_vocabulary_acquisition_and_use: @star_reading_test.language_vocabulary_acquisition_and_use, literature_craft_and_structure: @star_reading_test.literature_craft_and_structure, literature_key_ideas_and_details: @star_reading_test.literature_key_ideas_and_details, percentile_rank: @star_reading_test.percentile_rank, scaled_score: @star_reading_test.scaled_score, student_id: @star_reading_test.student_id, test_date: @star_reading_test.test_date } }
    assert_redirected_to star_reading_test_url(@star_reading_test)
  end

  test "should destroy star_reading_test" do
    assert_difference('StarReadingTest.count', -1) do
      delete star_reading_test_url(@star_reading_test)
    end

    assert_redirected_to star_reading_tests_url(student_id: @star_reading_test.student_id)
  end

  test "should download report" do 
    get star_reading_tests_download_report_docx_url(student_id: @star_reading_test.student_id)
    assert_response :success
  end 
end
