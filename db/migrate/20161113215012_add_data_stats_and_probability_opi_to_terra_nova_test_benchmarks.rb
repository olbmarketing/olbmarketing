class AddDataStatsAndProbabilityOpiToTerraNovaTestBenchmarks < ActiveRecord::Migration[5.0]
  def up
    add_column :terra_nova_test_benchmarks, :data_stats_and_probability_opi, :integer
  end

  def down 
    remove_column :terra_nova_test_benchmarks, :data_stats_and_probability_opi, :integer
  end 
end
