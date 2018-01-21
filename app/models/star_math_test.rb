class StarMathTest < ApplicationRecord
  belongs_to :student
  validates_inclusion_of :scaled_score, :in => 200..450, :message => "must be within 200 to 450"
  validates :test_date, presence: {message: "can't be blank or is incorrect format"}
end
