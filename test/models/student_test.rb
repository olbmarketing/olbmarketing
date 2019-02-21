require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

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
      preK_to_K: 'MyString', 
      father_name: 'father name', 
      mother_name: 'mother_name', 
      address: '', 
      city: '', 
      state: '', 
      zip: '', 
      email1: '', 
      email2: ''
    }
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

  test "cannot enter the same student in the same year more than once" do 
    student1 = Student.new(@new_student)
    student1.save
    student2 = Student.new(@new_student)
    assert student2.invalid?
    assert_equal ["A student cannot be entered into the system in a school year more than once!"], student2.errors[:first_name]
    # check that the next year one can enter student again 
    student2.school_year = add_school_year(student2.school_year)
    assert student2.valid?
  end 

  def add_school_year (year)
    first_year = year[0..3].to_i
    "#{first_year+1}-#{(first_year+2).to_s[-2..-1]}"
  end 

  test "should get correct first name" do 
    student = Student.new(@new_student)
    student.first_name = "Carter"
    result = student.get_first_name
    assert_equal "Carter", result
    student.first_name = "Danielle \"Dani\""
    result = student.get_first_name
    assert_equal "Danielle", result
    student.first_name = "Richard Jr. \"Ricky\""
    result = student.get_first_name
    assert_equal "Richard Jr.", result
    student.first_name = "Mary-Maginn"
    result = student.get_first_name
    assert_equal "Mary-Maginn", result
    # test single quote 
    student.first_name = "Danielle 'Dani'"
    result = student.get_first_name
    assert_equal "Danielle", result
  end 

  test "should get school year" do 
    my_school_year = '2016-17'
    assert_equal my_school_year, Student.get_school_year(Time.new(2016, 7, 1))
    assert_equal my_school_year, Student.get_school_year(Time.new(2017, 1, 7))
    assert_equal my_school_year, Student.get_school_year(Time.new(2017, 6, 30))
    
    my_school_year = '2017-18'
    assert_equal my_school_year, Student.get_school_year(Time.new(2017, 7, 1))
    assert_equal my_school_year, Student.get_school_year(Time.new(2018, 1, 7))
    assert_equal my_school_year, Student.get_school_year(Time.new(2018, 6, 30))
  end 

  test "should get past school years" do 
    n_year = 3
    result = Student.get_past_school_years(n_year, Time.new(2017, 1, 7))
    assert_equal n_year, result.count 
    assert_includes result, '2016-17'
    assert_includes result, '2015-16'
    assert_includes result, '2014-15'

    n_year = 3
    result = Student.get_past_school_years(n_year, Time.new(2017, 7, 1))
    assert_equal n_year, result.count 
    assert_includes result, '2017-18'
    assert_includes result, '2016-17'
    assert_includes result, '2015-16'

    n_year = 4
    result = Student.get_past_school_years(n_year, Time.new(2017, 7, 1))
    assert_equal n_year, result.count 
    assert_includes result, '2017-18'
    assert_includes result, '2016-17'
    assert_includes result, '2015-16'
    assert_includes result, '2014-15'

    n_year = 3
    result = Student.get_past_school_years(n_year, Time.new(2010, 1, 7))
    assert_equal n_year, result.count 
    assert_includes result, '2009-10'
    assert_includes result, '2008-09'
    assert_includes result, '2007-08'
  end 

  test "should get current school year students" do 
    current_sy_students_count = Student.get_students_by_sy(Student.get_school_year(Time.now)).count
    assert_equal 4, current_sy_students_count, ["the count needs to be 4"]
  end 

  test "should get 2000-01 school year students" do 
    current_sy_students_count = Student.get_students_by_sy('2000-01').count
    assert_equal 0, current_sy_students_count, ["the count needs to be 0"]
  end 

  test "should get 2015-16 school year students" do 
    current_sy_students_count = Student.get_students_by_sy('2015-16').count
    assert_equal 4, current_sy_students_count, ["the count needs to be 4"]
  end 

  test "should get last year student" do 
    current_student = Student.where("id = ?", 5).first
    #puts Student.get_school_year(Time.now - (60*60*24*365))
    last_year_student = current_student.get_prev_year_student
    assert_not_nil last_year_student
    assert_equal 9, last_year_student.id
  end 

  test "should get last year student - no student" do 
    current_student = Student.where("id = ?", 9).first
    #puts Student.get_school_year(Time.now - (60*60*24*365))
    last_year_student = current_student.get_prev_year_student
    assert_nil last_year_student
  end 

  test "should get previous school_year " do 
    school_year = '2018-19'
    prev_school_year = Student.school_year_add(school_year, -1)
    assert_equal '2017-18', prev_school_year
  end 

  test "should get previous school_year - boundary case 1 " do 
    school_year = '2000-01'
    prev_school_year = Student.school_year_add(school_year, -1)
    assert_equal '1999-00', prev_school_year
  end 

  test "should get previous school_year - boundary case 2 " do 
    school_year = '1999-00'
    prev_school_year = Student.school_year_add(school_year, -1)
    assert_equal '1998-99', prev_school_year
  end 

  test "should get next school_year " do 
    school_year = '2018-19'
    prev_school_year = Student.school_year_add(school_year, 1)
    assert_equal '2019-20', prev_school_year
  end 

  test "should get next school_year - boundary case 1" do 
    school_year = '1998-99'
    prev_school_year = Student.school_year_add(school_year, 1)
    assert_equal '1999-00', prev_school_year
  end 


  

end
