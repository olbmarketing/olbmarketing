class RemoveTerraNovaLevelFieldsFromTerraNovaTest < ActiveRecord::Migration[5.0]
  def up 
    remove_column :terra_nova_tests, :oral_comprehension_level, :string
    remove_column :terra_nova_tests, :basic_understanding_level, :string
    remove_column :terra_nova_tests, :introduction_to_print_level, :string
    remove_column :terra_nova_tests, :number_and_number_relations_level, :string
    remove_column :terra_nova_tests, :measurement_level, :string
    remove_column :terra_nova_tests, :geometry_and_spatial_sense_level, :string
    remove_column :terra_nova_tests, :data_stats_and_probability_level, :string
  end
  def down 
    add_column :terra_nova_tests, :oral_comprehension_level, :string
    add_column :terra_nova_tests, :basic_understanding_level, :string
    add_column :terra_nova_tests, :introduction_to_print_level, :string
    add_column :terra_nova_tests, :number_and_number_relations_level, :string
    add_column :terra_nova_tests, :measurement_level, :string
    add_column :terra_nova_tests, :geometry_and_spatial_sense_level, :string
    add_column :terra_nova_tests, :data_stats_and_probability_level, :string
  end 
end
