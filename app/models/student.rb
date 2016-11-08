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
    validates_uniqueness_of :first_name, scope: [:last_name, :school_year, :student_class, :father_name, :mother_name, :email1, :email2], 
      message: "A student cannot be entered into the system in a school year more than once!"

   def self.get_students_from_csv(my_csv)
    students = []
    # a block that run through a loop for each row in the csv file 
    my_csv.each do |row| 
      students << Student.new(row.to_hash)
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
    valid_column_names = ["first_name", "last_name", "school_year", "new_or_return", "student_class", "catholic", "parish", "race", "resides_with", "reference_from", "student_transfer", "preK_to_K", "father_name", "mother_name", "address", "city", "state", "zip", "email1", "email2"]
    header_convert_lambda = lambda do |name| 
      new_name = name 
      if !(valid_column_names.include? name)
        # change column names to meet backend needs
        new_name = name.strip.downcase.gsub " ", "_"
        new_name = "school_year" if new_name == "sy"
        new_name = "student_class" if new_name == "class"
        new_name  = "reference_from" if new_name == "referred_by"
        new_name  = "preK_to_K" if new_name == "transfer_from_prek_to_k"
        new_name  = "preK_to_K" if new_name == "Pre-K to K".strip.downcase.gsub(" ", "_")
        new_name  = "email1" if new_name == "father's_name"
        new_name  = "email2" if new_name == "mother's_name"
        new_name  = "email1" if new_name == "father_name"
        new_name  = "email2" if new_name == "mother_name"
        new_name  = "email1" if new_name == "father"
        new_name  = "email2" if new_name == "mother"
        new_name  = "reference_from" if new_name == "How You Heard About Us".strip.downcase.gsub(" ", "_")
        new_name  = "reference_from" if new_name == "Heard about OLB".strip.downcase.gsub(" ", "_")
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
end
