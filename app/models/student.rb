require 'roo'
class Student < ApplicationRecord
    has_many :exit_surveys, dependent: :destroy 
    has_many :terra_nova_tests, dependent: :destroy
    has_many :star_tests, dependent: :destroy
    validates :first_name, :last_name, :school_year, presence: true
    validates :school_year, format: {
        with: /\A\d{4}\-\d{2}\z/, 
        message: "must be the following format: YYYY-YY i.e. 2020-21"
    }
    validates_uniqueness_of :first_name, scope: [:last_name, :school_year, :student_class, :father_name, :mother_name, :email1, :email2, :phone1, :phone2], 
      message: "A student cannot be entered into the system in a school year more than once!"

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
    valid_column_names = ["first_name", "last_name", "school_year", "new_or_return", "student_class", "catholic", "parish", "race", "resides_with", "reference_from", "student_transfer", "preK_to_K", "father_name", "mother_name", "address", "city", "state", "zip", "email1", "email2", "note", "alumni", "address2", "city2", "state2", "zip2", "phone1", "phone2"]
    header_convert_lambda = lambda do |name| 
      new_name = name 
      if !(valid_column_names.include? name)
        # change column names to meet backend needs
        new_name = name.strip.downcase.gsub " ", "_"
        new_name = "last_name" if new_name == "student_last_name"
        new_name = "school_year" if new_name == "sy"
        new_name = "student_class" if new_name == "class"
        new_name  = "reference_from" if new_name == "referred_by"
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
        new_name  = "reference_from" if new_name == "How You Heard About Us".strip.downcase.gsub(" ", "_")
        new_name  = "reference_from" if new_name == "Heard about OLB".strip.downcase.gsub(" ", "_")
        new_name  = "note" if new_name == "notes"
      end 
      new_name
    end 
    my_csv = CSV.parse(csv_str, headers: true, header_converters: header_convert_lambda)
    my_csv
   end 

   def self.to_csv(options = {})
	  CSV.generate(options) do |csv|
	    csv << column_names
	    all.each do |student|
	      csv << student.attributes.values_at(*column_names)
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

  # sometimes first name can contain nicknames. want to get legal first name only
  def get_first_name
    input_name = send(:first_name)
    result = input_name
    if input_name.split('"').count > 1 
      result = input_name.split('"')[0].strip
    end 
    result
  end 
end
