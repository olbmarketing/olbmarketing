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

  test "get_level should get correct Mastery" do 
    assert_equal "High Mastery", TerraNovaTest.get_level(99)
    assert_equal "Moderate Mastery", TerraNovaTest.get_level(55)
    assert_equal "Low Mastery", TerraNovaTest.get_level(33)
  end 

  test "should have test date " do 
    my_tn_test = TerraNovaTest.new(@new_terra_nova_test)
    my_tn_test.test_date = nil
    assert my_tn_test.invalid?
    assert_equal ["can't be blank"], my_tn_test.errors[:test_date]
    # add test date and now it should be valid 
    my_tn_test.test_date = Date.new(2014, 1, 1)
    assert my_tn_test.valid?

  end 
  



end
