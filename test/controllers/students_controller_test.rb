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

    assert_redirected_to students_url
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

  test "import csv file import freash new records" do 
    # when upload with a student that's not yet in database. 
    # use different header format to test if they will be accepted
    csv_rows = CSV.generate(headers: true) do |csv|
      csv << ["first_name","Last Name", "SY", "extraColumn0", "How You Heard About Us", "extraColumn1", "Father / Mother"]
      csv << ["f1","l1", "2016-17", "ee", "dd", "e3e", "John / Emily"]
      csv << ["f2","l2", "2016-17", "ee", "ee", "ee", "Tom / Alice"]
    end
    file = Tempfile.new('new_users.csv')
    file.write(csv_rows)
    file.rewind

    assert_difference "Student.count", 2 do
      post "/students/import", params: { file: Rack::Test::UploadedFile.new(file, 'text/csv')}
    end
=begin
    # create a duplicate stduent should be invalid 
    dup_student = Student.new({first_name: "f1", last_name: "l1", school_year: "2016-17", father_name: "John", mother_name: "Emily"})
    assert dup_student.invalid?
    # post the csv the second time, should show validation error 

    post "/students/import", params: { file: Rack::Test::UploadedFile.new(file, 'text/csv')}

    assert_template :index
    assert_not_nil css_select('#error_explanation') 
=end 

  end 

  test "import csv file import old record to update" do 
    original_student_count = Student.count
    csv_rows = CSV.generate(headers: true) do |csv|
      csv << ["first_name","Last Name", "SY"]
      csv << ["f1","l1", "2016-17"]
    end
    insert_count = 1
    file = Tempfile.new('new_users.csv')
    file.write(csv_rows)
    file.rewind

    assert_difference "Student.count", insert_count do
      post "/students/import", params: { file: Rack::Test::UploadedFile.new(file, 'text/csv')}
      follow_redirect!
      assert_template :index
    end
    
    assert Student.count == original_student_count + insert_count
    s_first_name = 'f1'
    s_last_name = 'l1'
    s_school_year = '2016-17'
    s_address = "123 Main St."
    csv2_rows = CSV.generate(headers: true) do |csv|
      csv << ["first_name","Last Name", "SY", "Address"]
      csv << [s_first_name, s_last_name, s_school_year, s_address]
    end
    file2 = Tempfile.new('new_users_to_update.csv')
    file2.write(csv2_rows)
    file2.rewind

    post "/students/import", params: { file: Rack::Test::UploadedFile.new(file2, 'text/csv')}
    follow_redirect!
    assert_equal original_student_count + insert_count, Student.count
    query_results = Student.where('first_name = ? AND last_name = ?', s_first_name, s_last_name)
    student_from_db = query_results.first
    assert_equal 0, css_select('#error_explanation').count
    #puts css_select('html').first.to_s
    flash_notice = css_select('[id^=flash]')
    assert_operator flash_notice.count, :>, 0
    flash_notice_str = flash_notice.to_a.join
    assert_match '0 student(s) inserted', flash_notice_str
    assert_match '1 student(s) updated', flash_notice_str
    assert_equal s_address, student_from_db.address

  end 

  test "import csv file (one record) to update with no changes" do 
    original_student_count = Student.count
    s_first_name = 'f1'
    s_last_name = 'l1'
    s_school_year = '2016-17'
    s_address = "123 Main St."
    csv_rows = CSV.generate(headers: true) do |csv|
      csv << ["first_name","Last Name", "SY", "Address"]
      csv << [s_first_name, s_last_name, s_school_year, s_address]
    end
    insert_count = 1
    file = Tempfile.new('new_users.csv')
    file.write(csv_rows)
    file.rewind

    assert_difference "Student.count", insert_count do
      post "/students/import", params: { file: Rack::Test::UploadedFile.new(file, 'text/csv')}
      follow_redirect!
      assert_template :index
    end
    
    assert Student.count == original_student_count + insert_count
    
    csv2_rows = CSV.generate(headers: true) do |csv|
      csv << ["first_name","Last Name", "SY", "Address"]
      csv << [s_first_name, s_last_name, s_school_year, s_address]
    end
    file2 = Tempfile.new('new_users_to_update.csv')
    file2.write(csv2_rows)
    file2.rewind

    post "/students/import", params: { file: Rack::Test::UploadedFile.new(file2, 'text/csv')}
    follow_redirect!
    assert_equal original_student_count + insert_count , Student.count
    
    query_results = Student.where('first_name = ? AND last_name = ?', s_first_name, s_last_name)
    student_from_db = query_results.first
    assert_equal 0, css_select('#error_explanation').count
    #puts css_select('html').first.to_s
    flash_notice = css_select('[id^=flash]')
    assert_operator flash_notice.count, :>, 0
    flash_notice_str = flash_notice.to_a.join
    assert_match '0 student(s) inserted', flash_notice_str
    assert_match '0 student(s) updated', flash_notice_str
    assert_equal s_address, student_from_db.address
  end 

  test "import csv file (one record) to update with 2 matching records in DB" do 
    original_student_count = Student.count
    s_first_name = 'fname1'
    s_last_name = 'lname1'
    s_school_year = '2015-16'
    s_address = "123 Main St."
    csv_rows = CSV.generate(headers: true) do |csv|
      csv << ["first_name","Last Name", "SY", "Address"]
      csv << [s_first_name, s_last_name, s_school_year, s_address]
    end
    insert_count = 1
    file = Tempfile.new('new_users.csv')
    file.write(csv_rows)
    file.rewind

    assert_difference "Student.count", 0 do
      post "/students/import", params: { file: Rack::Test::UploadedFile.new(file, 'text/csv')}
      assert_template :index
    end
    flash_notice = css_select('[id^=flash]')
    assert_equal 0, flash_notice.count
    assert_not_nil css_select('#error_explanation') 
    assert_match 'There are more than 1 record in database with the same first_name, last_name, and school_year,please manually update respective data through web interface',
       css_select('#error_explanation').first.to_s
  end 

  # tset with multi-record import 
  test "import csv file (two record) both insert" do 
    original_student_count = Student.count
    s_first_name = 'f1'
    s_last_name = 'l1'
    s_school_year = '2016-17'
    s_address = "123 Main St."
    s2_first_name = 'f2'
    s2_last_name = 'l2'
    s2_school_year = '2016-17'
    s2_address = "234 Main St."
    csv_rows = CSV.generate(headers: true) do |csv|
      csv << ["first_name","Last Name", "SY", "Address"]
      csv << [s_first_name, s_last_name, s_school_year, s_address]
      csv << [s2_first_name, s2_last_name, s2_school_year, s2_address]
    end
    insert_count = 2
    file = Tempfile.new('new_users.csv')
    file.write(csv_rows)
    file.rewind

    assert_difference "Student.count", insert_count do
      post "/students/import", params: { file: Rack::Test::UploadedFile.new(file, 'text/csv')}
      follow_redirect!
      assert_template :index
    end
  end 

  test "import csv file (two record) 1 insert 1 update" do 
    original_student_count = Student.count
    s_first_name = 'f1'
    s_last_name = 'l1'
    s_school_year = '2016-17'
    s_address = "123 Main St."
    s2_first_name = 'fname2'
    s2_last_name = 'lname2'
    s2_school_year = '2015-16'
    s2_address = "234 Main St."
    csv_rows = CSV.generate(headers: true) do |csv|
      csv << ["first_name","Last Name", "SY", "Address"]
      csv << [s_first_name, s_last_name, s_school_year, s_address]
      csv << [s2_first_name, s2_last_name, s2_school_year, s2_address]
    end
    insert_count = 1
    file = Tempfile.new('new_users.csv')
    file.write(csv_rows)
    file.rewind

    assert_difference "Student.count", insert_count do
      post "/students/import", params: { file: Rack::Test::UploadedFile.new(file, 'text/csv')}
      follow_redirect!
      assert_template :index
    end

    query_results = Student.where('first_name = ? AND last_name = ? AND school_year = ?', s2_first_name, s2_last_name, s2_school_year)
    student_from_db = query_results.first
    assert_equal 0, css_select('#error_explanation').count
    #puts css_select('html').first.to_s
    flash_notice = css_select('[id^=flash]')
    assert_operator flash_notice.count, :>, 0
    flash_notice_str = flash_notice.to_a.join
    assert_match '1 student(s) inserted', flash_notice_str
    assert_match '1 student(s) updated', flash_notice_str
    assert_equal s2_address, student_from_db.address

  end 

  test "import csv file (two record) 2 update" do 
    original_student_count = Student.count
    s_first_name = 'fname2'
    s_last_name = 'lname2'
    s_school_year = '2015-16'
    s_address = "123 Main St."
    s2_first_name = 'fname4'
    s2_last_name = 'lname4'
    s2_school_year = '2015-16'
    s2_address = "234 Main St."
    csv_rows = CSV.generate(headers: true) do |csv|
      csv << ["first_name","Last Name", "SY", "Address"]
      csv << [s_first_name, s_last_name, s_school_year, s_address]
      csv << [s2_first_name, s2_last_name, s2_school_year, s2_address]
    end
    insert_count = 0
    file = Tempfile.new('new_users.csv')
    file.write(csv_rows)
    file.rewind

    assert_difference "Student.count", insert_count do
      post "/students/import", params: { file: Rack::Test::UploadedFile.new(file, 'text/csv')}
      follow_redirect!
      assert_template :index
    end

    s_query_results = Student.where('first_name = ? AND last_name = ? AND school_year = ?', s_first_name, s_last_name, s_school_year)
    s2_query_results = Student.where('first_name = ? AND last_name = ? AND school_year = ?', s2_first_name, s2_last_name, s2_school_year)
    student_from_db = s_query_results.first
    student2_from_db = s2_query_results.first
    assert_equal 0, css_select('#error_explanation').count
    #puts css_select('html').first.to_s
    flash_notice = css_select('[id^=flash]')
    assert_operator flash_notice.count, :>, 0
    flash_notice_str = flash_notice.to_a.join
    assert_match '0 student(s) inserted', flash_notice_str
    assert_match '2 student(s) updated', flash_notice_str
    assert_equal s_address, student_from_db.address
    assert_equal s2_address, student2_from_db.address
  end 

  test "import csv file (two record) only 1 update" do 
    original_student_count = Student.count
    s_first_name = 'fname2'
    s_last_name = 'lname2'
    s_school_year = '2015-16'
    s_address = "MyString"
    s2_first_name = 'fname4'
    s2_last_name = 'lname4'
    s2_school_year = '2015-16'
    s2_address = "234 Main St."
    csv_rows = CSV.generate(headers: true) do |csv|
      csv << ["first_name","Last Name", "SY", "Address"]
      csv << [s_first_name, s_last_name, s_school_year, s_address]
      csv << [s2_first_name, s2_last_name, s2_school_year, s2_address]
    end
    insert_count = 0
    file = Tempfile.new('new_users.csv')
    file.write(csv_rows)
    file.rewind

    assert_difference "Student.count", insert_count do
      post "/students/import", params: { file: Rack::Test::UploadedFile.new(file, 'text/csv')}
      follow_redirect!
      assert_template :index
    end

    s_query_results = Student.where('first_name = ? AND last_name = ? AND school_year = ?', s_first_name, s_last_name, s_school_year)
    s2_query_results = Student.where('first_name = ? AND last_name = ? AND school_year = ?', s2_first_name, s2_last_name, s2_school_year)
    student_from_db = s_query_results.first
    student2_from_db = s2_query_results.first
    assert_equal 0, css_select('#error_explanation').count
    #puts css_select('html').first.to_s
    flash_notice = css_select('[id^=flash]')
    assert_operator flash_notice.count, :>, 0
    flash_notice_str = flash_notice.to_a.join
    assert_match '0 student(s) inserted', flash_notice_str
    assert_match '1 student(s) updated', flash_notice_str
    assert_equal s_address, student_from_db.address
    assert_equal s2_address, student2_from_db.address
  end 

  test "import csv file (two record) only 1 insert" do 
    original_student_count = Student.count
    s_first_name = 'fname2'
    s_last_name = 'lname2'
    s_school_year = '2015-16'
    s_address = "MyString"
    s2_first_name = 'fname5'
    s2_last_name = 'lname5'
    s2_school_year = '2015-16'
    s2_address = "234 Main St."
    csv_rows = CSV.generate(headers: true) do |csv|
      csv << ["first_name","Last Name", "SY", "Address"]
      csv << [s_first_name, s_last_name, s_school_year, s_address]
      csv << [s2_first_name, s2_last_name, s2_school_year, s2_address]
    end
    insert_count = 1
    file = Tempfile.new('new_users.csv')
    file.write(csv_rows)
    file.rewind

    assert_difference "Student.count", insert_count do
      post "/students/import", params: { file: Rack::Test::UploadedFile.new(file, 'text/csv')}
      follow_redirect!
      assert_template :index
    end

    assert_equal 0, css_select('#error_explanation').count
    #puts css_select('html').first.to_s
    flash_notice = css_select('[id^=flash]')
    assert_operator flash_notice.count, :>, 0
    flash_notice_str = flash_notice.to_a.join
    assert_match '1 student(s) inserted', flash_notice_str
    assert_match '0 student(s) updated', flash_notice_str
  end 

  test "import csv file (two record) both not in DB but both are the same" do 
    original_student_count = Student.count
    s_first_name = 'f1'
    s_last_name = 'l1'
    s_school_year = '2015-16'
    s_address = "MyString"
    s2_first_name = 'f1'
    s2_last_name = 'l1'
    s2_school_year = '2015-16'
    s2_address = "MyString"
    csv_rows = CSV.generate(headers: true) do |csv|
      csv << ["first_name","Last Name", "SY", "Address"]
      csv << [s_first_name, s_last_name, s_school_year, s_address]
      csv << [s2_first_name, s2_last_name, s2_school_year, s2_address]
    end
    insert_count = 0
    file = Tempfile.new('new_users.csv')
    file.write(csv_rows)
    file.rewind

    assert_difference "Student.count", insert_count do
      post "/students/import", params: { file: Rack::Test::UploadedFile.new(file, 'text/csv')}
      assert_template :index
    end

    assert_not_nil css_select('#error_explanation') 
    assert_match 'Duplicate students in data source: student at row 2 and student at row 3 have the same first_name, last_name, school_year',
       css_select('#error_explanation').first.to_s
  end 

  test "import csv file (two record) both already in DB but both are the same" do 
    original_student_count = Student.count
    s_first_name = 'fname2'
    s_last_name = 'lname2'
    s_school_year = '2015-16'
    s_address = "MyString"
    s2_first_name = 'fname2'
    s2_last_name = 'lname2'
    s2_school_year = '2015-16'
    s2_address = "MyString"
    csv_rows = CSV.generate(headers: true) do |csv|
      csv << ["first_name","Last Name", "SY", "Address"]
      csv << [s_first_name, s_last_name, s_school_year, s_address]
      csv << [s2_first_name, s2_last_name, s2_school_year, s2_address]
    end
    insert_count = 0
    file = Tempfile.new('new_users.csv')
    file.write(csv_rows)
    file.rewind

    assert_difference "Student.count", insert_count do
      post "/students/import", params: { file: Rack::Test::UploadedFile.new(file, 'text/csv')}
      assert_template :index
    end

    assert_not_nil css_select('#error_explanation') 
    assert_match 'Duplicate students in data source: student at row 2 and student at row 3 have the same first_name, last_name, school_year',
       css_select('#error_explanation').first.to_s
  end 

=begin

  test "should be true" do 
    assert 1 == 1
  end 
=end 
end
