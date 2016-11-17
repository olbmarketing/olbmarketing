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

  # takes in tests attribute as hash add test result level for each category
  def self.hash_with_level(my_hash)
    my_hash.keys.each do |key|
      # if the key is an opi i.e. a test score, add level for this test score 
      if key.to_s =~ /\A.*opi\Z/ && my_hash[key]
        # conver opi to int if the has value is of type string 
        if my_hash[key] =~ /\A\d+\z/ 
          my_hash[key] = my_hash[key].to_i
        end 
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
    my_hash
  end 

  def self.get_level(opi)
    result = ""
    if opi 
      if (0..49).include? opi
        result = "Low Mastery"
      elsif (50..74).include? opi
        result = "Moderate Mastery"
      elsif opi > 74
        result = "High Mastery"
      end 
    end 
    result 
  end 

  def get_national_opi(test_category)
    result = 'NA'
    terra_nova_test_benchmarks = TerraNovaTestBenchmark.order(test_date: :desc).all
    tn_benchmark = terra_nova_test_benchmarks.find_by('test_date <= ?', send(:test_date))
    if tn_benchmark
      result = tn_benchmark[test_category]
    end 
    result
  end 
end
