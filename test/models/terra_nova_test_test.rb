require 'test_helper'

class TerraNovaTestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
    @terra_nova_test = star_tests(:one)
    @first_student = students(:one)
    @second_student = students(:two)
    @new_terra_nova_test = {
      student: @first_student,
      test_date: Date.new(2016,10,5),
      reading_scale_score: 581,
      reading_national_percentile: 77,
      oral_comprehension_opi: 89,
      basic_understanding_opi: 73,
      introduction_to_print_opi: 77, 
      math_scale_score: 35, 
      math_national_percentile: 78,
      number_and_number_relations_opi: 78, 
      measurement_opi: 66,
      geometry_and_spatial_sense_opi: 75, 
      data_stats_and_probability_opi: 89
    }
  end
  



end
