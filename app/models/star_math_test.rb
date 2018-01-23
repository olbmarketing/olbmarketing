class StarMathTest < ApplicationRecord
  belongs_to :student
  validates_inclusion_of :scaled_score, :in => 0..1400, :message => "must be within 0 to 1400"
  validates :test_date, presence: {message: "can't be blank or is incorrect format"}
end
