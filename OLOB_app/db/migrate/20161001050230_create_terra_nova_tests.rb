class CreateTerraNovaTests < ActiveRecord::Migration[5.0]
  def change
    create_table :terra_nova_tests do |t|
      t.belongs_to :student, foreign_key: true
      t.date :test_date
      t.integer :reading_scale_score
      t.integer :reading_national_percentile
      t.integer :oral_comprehension_opi
      t.string :oral_comprehension_level
      t.integer :basic_understanding_opi
      t.string :basic_understanding_level
      t.integer :introduction_to_print_opi
      t.string :introduction_to_print_level
      t.integer :math_scale_score
      t.integer :math_national_percentile
      t.integer :number_and_number_relations_opi
      t.string :number_and_number_relations_level
      t.integer :measurement_opi
      t.string :measurement_level
      t.integer :geometry_and_spatial_sense_opi
      t.string :geometry_and_spatial_sense_level
      t.integer :data_stats_and_probability_opi
      t.string :data_stats_and_probability_level

      t.timestamps
    end
  end
end
