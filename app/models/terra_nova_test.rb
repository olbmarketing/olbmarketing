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

  def get_most_recent_benchmark
    terra_nova_test_benchmarks = TerraNovaTestBenchmark.order(test_date: :desc).all
    terra_nova_test_benchmarks.find_by('test_date <= ?', send(:test_date))
  end 

  def get_national_opi(test_category)
    result = 'NA'
    tn_benchmark = get_most_recent_benchmark
    if tn_benchmark
      result = tn_benchmark[test_category]
    end 
    result
  end 

  # return 0 if national opi is not available 
  def get_national_opi_int(test_category)
    result = get_national_opi test_category
    result = 0 if result == 'NA'
    result 
  end 

  def get_opi_range(test_category)
    result = "NA"
    tn_benchmark = get_most_recent_benchmark
    if tn_benchmark
      result = tn_benchmark[test_category.to_s.sub('opi', 'moderate_mastery_range').to_sym]
    end 
    result
  end 

  def get_opi_mastery(test_category)
    result = "NA"
    range_str = get_opi_range(test_category)
    lower = range_str.split('-')[0].to_i
    higher = range_str.split('-')[1].to_i
    if send(test_category) < lower
      result = "Low Mastery"
    elsif send(test_category) > higher
      result = "High Mastery"
    else 
      result = "Moderate Mastery"
    end 
    result
  end 
end
