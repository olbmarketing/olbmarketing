class Parish < ApplicationRecord
  has_many :schools, dependent: :destroy

  geocoded_by :full_address
  after_validation :geocode

  def full_address
    return "" unless self.address && self.city && !self.address.empty? && !self.city.empty?
    return [self.address, self.city, self.state, self.zip].compact.reject(&:empty?).join(', ')
  end

end
