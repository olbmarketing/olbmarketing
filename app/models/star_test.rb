class StarTest < ApplicationRecord
  belongs_to :student
  validates_inclusion_of :scaled_score, :in => 200..1100, :message => "must be within 200 to 1100"
  validates :test_date, presence: {message: "can't be blank or is incorrect format"}
end
