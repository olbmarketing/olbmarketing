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
    validates :catholic, allow_blank: true, format: {
        with: /\A(Y|N|not listed)\z/,
        message: "must be \"Y\" or \"N\" or \"not listed\"" 
    }

   def self.import(file)
    # a block that run through a loop for each row in the csv file 
    if file.content_type == "text/csv"
      CSV.foreach(file.path, headers: true) do |row|
        #create a student for each row in CSV file 
        puts row.to_hash
        Student.create! row.to_hash
      end 
    else 
      book = Roo::Spreadsheet.open file.path
      sheet1 = book.sheet(0)
      csv_str = sheet1.to_csv
      my_csv = CSV.parse(csv_str, headers: true)
      my_csv.each do |row|
        #create a student for each row in CSV file 
        Student.create! row.to_hash
      end 
    end 
    
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
