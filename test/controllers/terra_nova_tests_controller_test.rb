require 'test_helper'

class TerraNovaTestsControllerTest < ActionDispatch::IntegrationTest
  fixtures :users
  setup do
    @terra_nova_test = terra_nova_tests(:one)
    @first_student = students(:one)
    @second_student = students(:two)
    @new_terra_nova_test = {
      student_id: @first_student.id,
      test_date: Date.new(2016,10,5),
      reading_scale_score: 581,
      reading_national_percentile: 77,
      oral_comprehension_opi: 89,
      basic_understanding_opi: 23,
      introduction_to_print_opi: 77, 
      math_scale_score: 515, 
      math_national_percentile: 78,
      number_and_number_relations_opi: 78, 
      measurement_opi: 66,
      geometry_and_spatial_sense_opi: 75, 
      data_stats_and_probability_opi: 89
    }
    login_setup
  end

  test "should get index" do
    get terra_nova_tests_url(student_id: @first_student.id)
    assert_response :success
  end

  test "should get new" do
    get new_terra_nova_test_url(student_id: @first_student.id)
    assert_response :success
  end

  test "should create terra_nova_test" do
    assert_difference('TerraNovaTest.count') do
      post terra_nova_tests_url, params: { terra_nova_test: { basic_understanding_opi: @terra_nova_test.basic_understanding_opi, data_stats_and_probability_opi: @terra_nova_test.data_stats_and_probability_opi, geometry_and_spatial_sense_opi: @terra_nova_test.geometry_and_spatial_sense_opi, introduction_to_print_opi: @terra_nova_test.introduction_to_print_opi, math_national_percentile: @terra_nova_test.math_national_percentile, math_scale_score: @terra_nova_test.math_scale_score,  measurement_opi: @terra_nova_test.measurement_opi, number_and_number_relations_opi: @terra_nova_test.number_and_number_relations_opi, oral_comprehension_opi: @terra_nova_test.oral_comprehension_opi, reading_national_percentile: @terra_nova_test.reading_national_percentile, reading_scale_score: @terra_nova_test.reading_scale_score, student_id: @terra_nova_test.student_id, test_date: @terra_nova_test.test_date } }
    end

    assert_redirected_to terra_nova_test_url(TerraNovaTest.last)
  end

  test "should show terra_nova_test" do
    get terra_nova_test_url(@terra_nova_test)
    assert_response :success
  end

  test "should get edit" do
    get edit_terra_nova_test_url(@terra_nova_test)
    assert_response :success
  end

  test "should update terra_nova_test" do
    patch terra_nova_test_url(@terra_nova_test), params: { terra_nova_test: { basic_understanding_opi: @terra_nova_test.basic_understanding_opi, data_stats_and_probability_opi: @terra_nova_test.data_stats_and_probability_opi, geometry_and_spatial_sense_opi: @terra_nova_test.geometry_and_spatial_sense_opi, introduction_to_print_opi: @terra_nova_test.introduction_to_print_opi, math_national_percentile: @terra_nova_test.math_national_percentile, math_scale_score: @terra_nova_test.math_scale_score,  measurement_opi: @terra_nova_test.measurement_opi, number_and_number_relations_opi: @terra_nova_test.number_and_number_relations_opi, oral_comprehension_opi: @terra_nova_test.oral_comprehension_opi, reading_national_percentile: @terra_nova_test.reading_national_percentile, reading_scale_score: @terra_nova_test.reading_scale_score, student_id: @terra_nova_test.student_id, test_date: @terra_nova_test.test_date } }
    assert_redirected_to terra_nova_test_url(@terra_nova_test)
  end

  test "should destroy terra_nova_test" do
    assert_difference('TerraNovaTest.count', -1) do
      delete terra_nova_test_url(@terra_nova_test)
    end

    assert_redirected_to terra_nova_tests_url(student_id: @terra_nova_test.student.id)
  end

  test "should post to create without levels" do 
    assert_difference('TerraNovaTest.count', 1) do
      post terra_nova_tests_url, params: { terra_nova_test: @new_terra_nova_test}
    end 
    # get the newly created test and check to see if levels are inserted 
    get terra_nova_test_url(TerraNovaTest.all.last) + '.json'
    returned_terra_nova = JSON.parse(response.body)
=begin
    assert_equal "High Mastery", returned_terra_nova['oral_comprehension_level'], "after update the oral_comprehension_opi level should be High Mastery"
    assert_equal "Low Mastery", returned_terra_nova['basic_understanding_level'], "after update the basic_understanding_opi level should be Low Mastery"
    assert_equal "Moderate Mastery", returned_terra_nova['measurement_level'], "after update the measurement_opi level should be Moderate Mastery"
=end
  end 

  test "should update terra_nova_test basic_understanding_opi" do
    # update the @terra_nova_test basic_understanding_opi with original + 1
    patch terra_nova_test_url(@terra_nova_test), params: { terra_nova_test: { basic_understanding_opi: @terra_nova_test.basic_understanding_opi + 1, data_stats_and_probability_opi: @terra_nova_test.data_stats_and_probability_opi, geometry_and_spatial_sense_opi: @terra_nova_test.geometry_and_spatial_sense_opi, introduction_to_print_opi: @terra_nova_test.introduction_to_print_opi, math_national_percentile: @terra_nova_test.math_national_percentile, math_scale_score: @terra_nova_test.math_scale_score,  measurement_opi: @terra_nova_test.measurement_opi, number_and_number_relations_opi: @terra_nova_test.number_and_number_relations_opi, oral_comprehension_opi: @terra_nova_test.oral_comprehension_opi, reading_national_percentile: @terra_nova_test.reading_national_percentile, reading_scale_score: @terra_nova_test.reading_scale_score, student_id: @terra_nova_test.student_id, test_date: @terra_nova_test.test_date } }
    assert_redirected_to terra_nova_test_url(@terra_nova_test)
    # assert the updated terra_nova_test basic_understanding_opi should be original + 1
    get terra_nova_test_url(@terra_nova_test) + '.json'
    returned_terra_nova = JSON.parse(response.body)
    assert_equal @terra_nova_test.basic_understanding_opi + 1, returned_terra_nova['basic_understanding_opi'], "after update the oral_comprehension_opi level should be updated "
  end 

  test "create new terra nova test object" do 
    obj = TerraNovaTest.new 
    assert_nil obj.reading_scale_score
  end 

end
