require 'test_helper'

class TerraNovaTestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @terra_nova_test = terra_nova_tests(:one)
  end

  test "should get index" do
    get terra_nova_tests_url
    assert_response :success
  end

  test "should get new" do
    get new_terra_nova_test_url
    assert_response :success
  end

  test "should create terra_nova_test" do
    assert_difference('TerraNovaTest.count') do
      post terra_nova_tests_url, params: { terra_nova_test: { basic_understanding_level: @terra_nova_test.basic_understanding_level, basic_understanding_opi: @terra_nova_test.basic_understanding_opi, data_stats_and_probability_level: @terra_nova_test.data_stats_and_probability_level, data_stats_and_probability_opi: @terra_nova_test.data_stats_and_probability_opi, geometry_and_spatial_sense_level: @terra_nova_test.geometry_and_spatial_sense_level, geometry_and_spatial_sense_opi: @terra_nova_test.geometry_and_spatial_sense_opi, introduction_to_print_level: @terra_nova_test.introduction_to_print_level, introduction_to_print_opi: @terra_nova_test.introduction_to_print_opi, math_national_percentile: @terra_nova_test.math_national_percentile, math_scale_score: @terra_nova_test.math_scale_score, measurement_level: @terra_nova_test.measurement_level, measurement_opi: @terra_nova_test.measurement_opi, number_and_number_relations_level: @terra_nova_test.number_and_number_relations_level, number_and_number_relations_opi: @terra_nova_test.number_and_number_relations_opi, oral_comprehension_level: @terra_nova_test.oral_comprehension_level, oral_comprehension_opi: @terra_nova_test.oral_comprehension_opi, reading_national_percentile: @terra_nova_test.reading_national_percentile, reading_scale_score: @terra_nova_test.reading_scale_score, student_id: @terra_nova_test.student_id, test_date: @terra_nova_test.test_date } }
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
    patch terra_nova_test_url(@terra_nova_test), params: { terra_nova_test: { basic_understanding_level: @terra_nova_test.basic_understanding_level, basic_understanding_opi: @terra_nova_test.basic_understanding_opi, data_stats_and_probability_level: @terra_nova_test.data_stats_and_probability_level, data_stats_and_probability_opi: @terra_nova_test.data_stats_and_probability_opi, geometry_and_spatial_sense_level: @terra_nova_test.geometry_and_spatial_sense_level, geometry_and_spatial_sense_opi: @terra_nova_test.geometry_and_spatial_sense_opi, introduction_to_print_level: @terra_nova_test.introduction_to_print_level, introduction_to_print_opi: @terra_nova_test.introduction_to_print_opi, math_national_percentile: @terra_nova_test.math_national_percentile, math_scale_score: @terra_nova_test.math_scale_score, measurement_level: @terra_nova_test.measurement_level, measurement_opi: @terra_nova_test.measurement_opi, number_and_number_relations_level: @terra_nova_test.number_and_number_relations_level, number_and_number_relations_opi: @terra_nova_test.number_and_number_relations_opi, oral_comprehension_level: @terra_nova_test.oral_comprehension_level, oral_comprehension_opi: @terra_nova_test.oral_comprehension_opi, reading_national_percentile: @terra_nova_test.reading_national_percentile, reading_scale_score: @terra_nova_test.reading_scale_score, student_id: @terra_nova_test.student_id, test_date: @terra_nova_test.test_date } }
    assert_redirected_to terra_nova_test_url(@terra_nova_test)
  end

  test "should destroy terra_nova_test" do
    assert_difference('TerraNovaTest.count', -1) do
      delete terra_nova_test_url(@terra_nova_test)
    end

    assert_redirected_to terra_nova_tests_url
  end
end
