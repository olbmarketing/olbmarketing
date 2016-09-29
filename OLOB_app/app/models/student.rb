class Student < ApplicationRecord
    validates :first_name, :last_name, :school_year, presence: true
    validates :school_year, format: {
        with: /\A\d{4}\-\d{2}\z/, 
        message: "must be the following format: YYYY-YY i.e. 2020-21"
    }
    validates :catholic, allow_blank: true, format: {
        with: /\A(Y|N|not listed)\z/,
        message: "must be \"Y\" or \"N\" or \"not listed\"" 
    }
   
   def self.to_csv(options = {})
	  CSV.generate(options) do |csv|
	    csv << column_names
	    all.each do |student|
	      csv << student.attributes.values_at(*column_names)
	    end
	  end
	end 
end
