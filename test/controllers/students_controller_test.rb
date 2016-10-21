require 'test_helper'

class StudentsControllerTest < ActionDispatch::IntegrationTest
  fixtures :users
  setup do
    @student = students(:one)
    @new_student = {
      first_name: 'new_fname',
      last_name: 'lname1',
      school_year: '2015-16',
      new_or_return: 'New',
      student_class: 'PreK',
      catholic: 'Y',
      parish: 'MyString',
      race: 'MyString',
      resides_with: 'Mom',
      reference_from: 'MyString',
      student_transfer: 'MyString',
      preK_to_K: 'MyString'
    }
    login_setup
  end

  test "should get index" do
    get students_url
    assert_response :success
  end

  test "should get new" do
    get new_student_url
    assert_response :success
  end

  test "should create student" do
    assert_difference('Student.count') do
      post students_url, params:{ student: @new_student }
    end

    assert_redirected_to student_url(Student.last)
  end

  test "should show student" do
    get student_url(@student)
    assert_response :success
  end

  test "should get edit" do
    get edit_student_url(@student)
    assert_response :success
  end

  test "should update student" do
    patch student_url(@student), params: { student: @new_student}
  end

  test "should destroy student" do
    assert_difference('Student.count', -1) do
      delete student_url(@student)
    end

    assert_redirected_to students_url
  end

  test "school_year must be valid" do
    student = Student.new(@new_student)
    wrong_formats = ["2000", "2000-1", "2000-111"]
    wrong_formats.each do |wrong_format|
      student.school_year = wrong_format
      assert student.invalid?
      assert_equal ["must be the following format: YYYY-YY i.e. 2020-21"], student.errors[:school_year]
    end 

    valid_formats = ["2001-02", "2011-12"]
    valid_formats.each do |valid_format|
      student.school_year = valid_format
      assert student.valid?
    end 
  end 

  test "catholic must be valid" do 
    student = Student.new(@new_student)
    wrong_formats = ["fnee", "ac", "YYY"]
    wrong_formats.each do |wrong_format|
      student.catholic = wrong_format
      assert student.invalid?
      assert_equal ["must be \"Y\" or \"N\" or \"not listed\"" ], student.errors[:catholic]
    end 

    valid_formats = ["Y", "N", "not listed", ""]
    valid_formats.each do |valid_format|
      student.catholic = valid_format
      assert student.valid?
    end 
  end 
=begin

  test "should be true" do 
    assert 1 == 1
  end 
=end 
end
