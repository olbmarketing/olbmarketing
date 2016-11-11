class TerraNovaTest < ApplicationRecord
  belongs_to :student
  validates :test_date, presence: true

  # special create that add test result level for each category
  def self.s_create!(my_hash)
    my_hash.keys.each do |key|
      # if the key is an opi i.e. a test score, add level for this test score 
      if key.to_s =~ /\A.*opi\Z/ && my_hash[key]
        level_sym = (key.to_s.sub 'opi', 'level').to_sym
        if (0..49).include? my_hash[key]
          my_hash[level_sym] = "Low Mastery"
        elsif (50..74).include? my_hash[key] 
          my_hash[level_sym] = "Moderate Mastery"
        elsif my_hash[key] > 74
          my_hash[level_sym] = "High Mastery"
        end  
      end 
    end 
    
    self.create!(my_hash)
  end 
end
