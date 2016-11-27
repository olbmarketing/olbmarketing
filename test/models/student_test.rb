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
  end 

end
