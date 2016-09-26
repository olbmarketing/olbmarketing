class Student < ApplicationRecord
    validates :first_name, :last_name, :school_year, presence: true
    validates :school_year, format: {
        with: /\A\d{4}\-\d{2}\z/, 
        message: "must be the following format: YYYY-YY i.e. 2020-21"
    }
    validates :catholic, allow_blank: true, format: {
        with: /(Y|N|not listed)/,
        message: "must be Y or N" 
    }
    validates :last_name, format: {
        with: /(Y|N|not listed)/,
        message: "must be Y or N" 
    }
end
