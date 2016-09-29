class Parish < ApplicationRecord
  has_many :schools, dependent: :destroy
end
