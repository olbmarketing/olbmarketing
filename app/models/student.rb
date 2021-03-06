require 'roo'
require 'geocoder'
class Student < ApplicationRecord
  
  has_many :exit_surveys, dependent: :destroy
  has_many :terra_nova_tests, dependent: :destroy
  has_many :star_tests, dependent: :destroy
  has_many :star_math_tests, dependent: :destroy
  has_many :star_reading_tests, dependent: :destroy
  validates :first_name, :last_name, :school_year, presence: true
  validates :school_year, format: {
      with: /\A\d{4}\-\d{2}\z/,
      message: "must be the following format: YYYY-YY i.e. 2020-21"
  }
  validates_uniqueness_of :first_name, scope: [:last_name, :school_year],
    message: "A student cannot be entered into the system in a school year more than once!"

  geocoded_by :full_address
  after_validation :geocode

  def full_address
    return "" unless self.address && self.city && !self.address.empty? && !self.city.empty?
    return [self.address, self.city, self.state, self.zip].compact.reject(&:empty?).join(', ')
  end

  def self.get_valid_fields
    return ["first_name", "last_name", "school_year", "new_or_return", "reason_new_or_return", "toddler_to_ttt", "ttt_to_ps", "reason_ttt_to_ps", "ps_to_prek", "reason_ps_to_prek", "preK_to_K", "reason_prek_to_k", "K_First", "student_class", "catholic", "parish", "race", "resides_with", "reference_from", "student_transfer", "father_name", "mother_name", "address", "city", "state", "zip", "address2", "city2", "state2", "zip2", "email1", "email2", "phone1", "phone2", "gender", "note", "reason"]
  end

  def self.get_display_fields
    return ["First Name", "Last Name", "School Year", "New or Return", "Reason for New or Return", "Toddler to TTT", "TTT to PS", "Reason: TTT to PS", "PS to PreK", "Reason: PS to PreK", "Pre K to K", "Reason: PreK to K", "K to 1st", "Student Class", "Catholic", "Parish", "Race", "Resides With", "Referred By", "Student Transfer", "Father Name", "Mother Name", "Address", "City", "State", "Zip", "Address2", "City2", "State2", "Zip2", "Father Email", "Mother Email", "Phone1", "Phone2", "Gender", "Note", "Reason"]
  end 

  def self.get_reason_fields
    my_hash = {}
    reason_valid_fields = Student.get_valid_fields.select {|item| /^reason/i.match item}
    reason_display_fields = Student.get_display_fields.select {|item| /^reason/i.match item}
    reason_valid_fields.each_with_index do |item, index|
      my_hash[item] = reason_display_fields[index]
    end 
    my_hash
  end 

  def self.get_students_from_csv(my_csv)
    students = []
    # a block that run through a loop for each row in the csv file
    my_csv.each do |row|
      # clean up email formating (remove mailto: prefix)
      tmp_hash = row.to_hash
      row.headers.each do |h|
        if tmp_hash[h] =~ /\Amailto:.*\z/i
          tmp_hash[h] = tmp_hash[h].sub 'mailto:', ''
          tmp_hash[h] = tmp_hash[h].strip
        end
      end
      students << Student.new(tmp_hash)
    end
    students
  end

   def self.get_csv_from_file(file)
    csv_str = ""
    if !(file.content_type == "text/csv")
      book = Roo::Spreadsheet.open file.path
      sheet1 = book.sheet(0)
      csv_str = sheet1.to_csv
    else
      csv_str = file.read
    end
    csv_str = Student.split_parent_column csv_str
    valid_column_names = Student.get_valid_fields
    header_convert_lambda = lambda do |name|
      new_name = name
      if !(valid_column_names.include? name)
        # change column names to meet backend needs
        new_name = name.strip.downcase.gsub(" ", "_").gsub(":", "")
        new_name = "last_name" if new_name == "student_last_name"
        new_name = "first_name" if new_name == "first"
        new_name = "last_name" if new_name == "last"
        new_name = "school_year" if new_name == "sy"
        new_name = "student_class" if new_name == "class"
        new_name = "new_or_return" if new_name == "student_type"
        new_name  = "reference_from" if new_name == "referred_by"
        new_name  = "preK_to_K" if new_name == "pre_k_to_k"
        new_name  = "preK_to_K" if new_name == "transfer_from_prek_to_k"
        new_name  = "preK_to_K" if new_name == "Pre-K to K".strip.downcase.gsub(" ", "_")
        new_name  = "email1" if new_name == "email"
        new_name  = "email1" if new_name == "email_1"
        new_name  = "email2" if new_name == "email_2"
        new_name  = "email1" if new_name == "father's_email"
        new_name  = "email2" if new_name == "mother's_email"
        new_name  = "email1" if new_name == "father_email"
        new_name  = "email2" if new_name == "mother_email"
        new_name  = "phone1" if new_name == "phone_1"
        new_name  = "phone2" if new_name == "phone_2"
        new_name  = "father_name" if new_name == "father"
        new_name  = "mother_name" if new_name == "mother"
        new_name  = "father_name" if new_name == "father's_name"
        new_name  = "mother_name" if new_name == "mother's_name"
        new_name  = "reference_from" if new_name == "How You Heard About Us".strip.downcase.gsub(" ", "_")
        new_name  = "reference_from" if new_name == "Heard about OLB".strip.downcase.gsub(" ", "_")
        new_name  = "note" if new_name == "notes"
        new_name  = "K_First" if new_name == "K to 1st Grade".strip.downcase.gsub(" ", "_")
        new_name  = "K_First" if new_name == "K to 1st".strip.downcase.gsub(" ", "_")
        new_name = "reason_new_or_return" if new_name == "Reason for New or Return".strip.downcase.gsub(" ", "_")
      end
      new_name
    end
    my_csv = CSV.parse(csv_str, headers: true, header_converters: header_convert_lambda)
    my_csv
   end

   def self.to_csv(options = {})
	  CSV.generate(options) do |csv|
	    csv << Student.get_display_fields
	    Student.all.each do |student|
	      csv << student.attributes.values_at(*(Student.get_valid_fields))
	    end
	  end
	end
  # split parent column if father and mother in the same field
  def self.split_parent_column(csv_str)
    if csv_str.include? "Father / Mother"
      my_csv = CSV.parse(csv_str, headers: true)
      parent_column = my_csv["Father / Mother"]
      father_names = []
      mother_names = []
      parent_column.each do |p|
        father = nil
        mother = nil
        if p && p.split("/").count == 2
          father = p.split("/")[0].strip
          mother = p.split("/")[1].strip
        elsif p && p.length > 0
          father = p
        end
        father_names << father
        mother_names << mother
      end
      my_csv["Father / Mother"] = father_names
      my_csv["mother_name"] = mother_names
      my_csv.to_s.sub "Father / Mother", "father_name"
    else
      csv_str
    end
  end

  def self.get_school_year(my_time)
    if my_time.month <= 6 
      current_year = my_time.year
      "#{current_year-1}-#{current_year.to_s[2..-1]}"
    else
      current_year = my_time.year
      "#{current_year}-#{(current_year+1).to_s[2..-1]}"
    end 
  end 

  def self.get_past_school_years(n_year, my_time)
    result = []
    my_school_year = Student.get_school_year(my_time)
    n_year.times do |i|
      result << "#{my_school_year[0..3].to_i - i}-#{(my_school_year[-2..-1].to_i - i).to_s.rjust(2,'0')}"
    end 
    result
  end 

  def self.get_students_by_sy(school_year)
    Student.where(school_year: school_year).order('last_name')
  end 

  # sometimes first name can contain nicknames. want to get legal first name only
  def get_first_name
    input_name = send(:first_name)
    result = input_name
    if input_name.split("'").count > 1
      result = input_name.split("'")[0].strip
    elsif input_name.split('"').count > 1
      result = input_name.split('"')[0].strip
    end
    result
  end

end
