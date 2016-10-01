require 'test_helper'

class TerraNovaTestBenchmarksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @terra_nova_test_benchmark = terra_nova_test_benchmarks(:one)
  end

  test "should get index" do
    get terra_nova_test_benchmarks_url
    assert_response :success
  end

  test "should get new" do
    get new_terra_nova_test_benchmark_url
    assert_response :success
  end

  test "should create terra_nova_test_benchmark" do
    assert_difference('TerraNovaTestBenchmark.count') do
      post terra_nova_test_benchmarks_url, params: { terra_nova_test_benchmark: { basic_understanding_opi: @terra_nova_test_benchmark.basic_understanding_opi, geometry_and_spatial_sense_opi: @terra_nova_test_benchmark.geometry_and_spatial_sense_opi, introduction_to_print_opi: @terra_nova_test_benchmark.introduction_to_print_opi, measurement_opi: @terra_nova_test_benchmark.measurement_opi, number_and_number_relations_opi: @terra_nova_test_benchmark.number_and_number_relations_opi, oral_comprehension_opi: @terra_nova_test_benchmark.oral_comprehension_opi, test_date: @terra_nova_test_benchmark.test_date } }
    end

    assert_redirected_to terra_nova_test_benchmark_url(TerraNovaTestBenchmark.last)
  end

  test "should show terra_nova_test_benchmark" do
    get terra_nova_test_benchmark_url(@terra_nova_test_benchmark)
    assert_response :success
  end

  test "should get edit" do
    get edit_terra_nova_test_benchmark_url(@terra_nova_test_benchmark)
    assert_response :success
  end

  test "should update terra_nova_test_benchmark" do
    patch terra_nova_test_benchmark_url(@terra_nova_test_benchmark), params: { terra_nova_test_benchmark: { basic_understanding_opi: @terra_nova_test_benchmark.basic_understanding_opi, geometry_and_spatial_sense_opi: @terra_nova_test_benchmark.geometry_and_spatial_sense_opi, introduction_to_print_opi: @terra_nova_test_benchmark.introduction_to_print_opi, measurement_opi: @terra_nova_test_benchmark.measurement_opi, number_and_number_relations_opi: @terra_nova_test_benchmark.number_and_number_relations_opi, oral_comprehension_opi: @terra_nova_test_benchmark.oral_comprehension_opi, test_date: @terra_nova_test_benchmark.test_date } }
    assert_redirected_to terra_nova_test_benchmark_url(@terra_nova_test_benchmark)
  end

  test "should destroy terra_nova_test_benchmark" do
    assert_difference('TerraNovaTestBenchmark.count', -1) do
      delete terra_nova_test_benchmark_url(@terra_nova_test_benchmark)
    end

    assert_redirected_to terra_nova_test_benchmarks_url
  end
end
