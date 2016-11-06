require 'test_helper'
require 'csv'

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

  test "import csv file" do 
    # use different header format to test if they will be accepted
    csv_rows = CSV.generate(headers: true) do |csv|
      csv << ["first_name","Last Name", "SY", "How You Heard About Us"]
      csv << ["f1","l1", "2016-17", "dd"]
      csv << ["f2","l2", "2016-17", "ee"]
    end
    file = Tempfile.new('new_users.csv')
    file.write(csv_rows)
    file.rewind

    assert_difference "Student.count", 2 do
      post "/students/import", params: { file: Rack::Test::UploadedFile.new(file, 'text/csv')}
    end


    # create a duplicate stduent should be invalid 
    dup_student = Student.new({first_name: "f1", last_name: "l1", school_year: "2016-17"})
    assert dup_student.invalid?
    # post the csv the second time, should show validation error 
    post "/students/import", params: { file: Rack::Test::UploadedFile.new(file, 'text/csv')}
    assert_template :index
    assert_not_nil css_select('#error_explanation') 
    

  end 


=begin

  test "should be true" do 
    assert 1 == 1
  end 
=end 
end
