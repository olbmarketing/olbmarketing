class AddOralComprehensionOpiLevelToTerraNovaTestBenchmarks < ActiveRecord::Migration[5.0]
  def up
    add_column :terra_nova_test_benchmarks, :oral_comprehension_moderate_mastery_range, :string
    add_column :terra_nova_test_benchmarks, :basic_understanding_moderate_mastery_range, :string
    add_column :terra_nova_test_benchmarks, :introduction_to_print_moderate_mastery_range, :string
    add_column :terra_nova_test_benchmarks, :number_and_number_relations_moderate_mastery_range, :string
    add_column :terra_nova_test_benchmarks, :measurement_moderate_mastery_range, :string
    add_column :terra_nova_test_benchmarks, :geometry_and_spatial_sense_moderate_mastery_range, :string
    add_column :terra_nova_test_benchmarks, :data_stats_and_probability_moderate_mastery_range, :string
  end
  def down 
    remove_column :terra_nova_test_benchmarks, :oral_comprehension_moderate_mastery_range, :string
    remove_column :terra_nova_test_benchmarks, :basic_understanding_moderate_mastery_range, :string
    remove_column :terra_nova_test_benchmarks, :introduction_to_print_moderate_mastery_range, :string
    remove_column :terra_nova_test_benchmarks, :number_and_number_relations_moderate_mastery_range, :string
    remove_column :terra_nova_test_benchmarks, :measurement_moderate_mastery_range, :string
    remove_column :terra_nova_test_benchmarks, :geometry_and_spatial_sense_moderate_mastery_range, :string
    remove_column :terra_nova_test_benchmarks, :data_stats_and_probability_moderate_mastery_range, :string
  end 
end
