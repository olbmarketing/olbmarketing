require 'test_helper'

class StarMathTestsControllerTest < ActionDispatch::IntegrationTest
  fixtures :users
  setup do
    @star_math_test = star_math_tests(:one)
    @first_student = students(:one)
    @second_student = students(:two)
    login_setup
  end

  test "should get index" do
    get star_math_tests_url(student_id: @first_student.id)
    assert_response :success
  end

  test "should get new" do
    get new_star_math_test_url(student_id: @first_student.id)
    assert_response :success
  end

  test "should create star_math_test" do
    assert_difference('StarMathTest.count') do
      post star_math_tests_url, params: { star_math_test: { algebra: @star_math_test.algebra, geometry: @star_math_test.geometry, measurement_and_data: @star_math_test.measurement_and_data, numbers_and_operations: @star_math_test.numbers_and_operations, scaled_score: @star_math_test.scaled_score, student_id: @star_math_test.student_id, test_date: @star_math_test.test_date } }
    end

    assert_redirected_to star_math_tests_url(student_id: @star_math_test.student_id)
  end

  test "should show star_math_test" do
    get star_math_test_url(@star_math_test)
    assert_response :success
  end

  test "should get edit" do
    get edit_star_math_test_url(@star_math_test)
    assert_response :success
  end

  test "should update star_math_test" do
    patch star_math_test_url(@star_math_test), params: { star_math_test: { algebra: @star_math_test.algebra, geometry: @star_math_test.geometry, measurement_and_data: @star_math_test.measurement_and_data, numbers_and_operations: @star_math_test.numbers_and_operations, scaled_score: @star_math_test.scaled_score, student_id: @star_math_test.student_id, test_date: @star_math_test.test_date } }
    assert_redirected_to star_math_test_url(@star_math_test)
  end

  test "should destroy star_math_test" do
    assert_difference('StarMathTest.count', -1) do
      delete star_math_test_url(@star_math_test)
    end

    assert_redirected_to star_math_tests_url(student_id: @star_math_test.student_id)
  end
end
