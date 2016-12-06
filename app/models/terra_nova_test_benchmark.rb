class TerraNovaTestBenchmark < ApplicationRecord
    validates :test_date, presence: true
    validates :oral_comprehension_moderate_mastery_range, :basic_understanding_moderate_mastery_range, :introduction_to_print_moderate_mastery_range, :number_and_number_relations_moderate_mastery_range, :measurement_moderate_mastery_range, :geometry_and_spatial_sense_moderate_mastery_range, :data_stats_and_probability_moderate_mastery_range, format: {
        with: /\A(\d{2}|\d)\-\d{2}\z/, 
        message: "moderate mastery range must be in xx-xx. i.e. 55-74"
    }
end
