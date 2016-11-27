require 'test_helper'

class TerraNovaTestBenchmarkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
    @terra_nova_test_benchmark = terra_nova_test_benchmarks(:one)
    @first_student = students(:one)
    @second_student = students(:two)
    @new_terra_nova_test_benchmark = {
      test_date: Date.new(2016,10,5),
      oral_comprehension_opi: 1,
      oral_comprehension_moderate_mastery_range: '10-15',
      basic_understanding_opi: 1,
      basic_understanding_moderate_mastery_range: '50-60',
      introduction_to_print_opi: 1,
      introduction_to_print_moderate_mastery_range: '50-60',
      number_and_number_relations_opi: 1,
      number_and_number_relations_moderate_mastery_range: '50-60',
      measurement_opi: 1,
      measurement_moderate_mastery_range: '50-60',
      geometry_and_spatial_sense_opi: 1,
      geometry_and_spatial_sense_moderate_mastery_range: '50-60',
      data_stats_and_probability_opi: 1,
      data_stats_and_probability_moderate_mastery_range: '50-60'
    }
  end

  test "oral_comprehension_range must be valid" do
    terra_nova_test_benchmark = TerraNovaTestBenchmark.new(@new_terra_nova_test_benchmark)
    wrong_formats = ["2000", "200-1", "200-111"]
    terra_nova_test_benchmark.attributes.keys.each do |attr_name|
      if attr_name =~ /\A.*range\z/
        wrong_formats.each do |wrong_format|
          terra_nova_test_benchmark[attr_name] = wrong_format
          assert terra_nova_test_benchmark.invalid?
          assert_equal ["moderate mastery range must be in xx-xx. i.e. 55-74"], terra_nova_test_benchmark.errors[attr_name]
        end 

        valid_formats = ["20-24", "50-60"]
        valid_formats.each do |valid_format|
          terra_nova_test_benchmark[attr_name] = valid_format
          assert terra_nova_test_benchmark.valid?
        end 
      end 
    end 
    
  end 
end
