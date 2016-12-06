class StarTest < ApplicationRecord
  belongs_to :student
  validates_inclusion_of :scaled_score, :in => 300..900, :message => "must be within 300 to 900"
  validates :test_date, presence: {message: "can't be blank or is incorrect format"}
end
