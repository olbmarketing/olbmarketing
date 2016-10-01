class CreateTerraNovaTestBenchmarks < ActiveRecord::Migration[5.0]
  def change
    create_table :terra_nova_test_benchmarks do |t|
      t.date :test_date
      t.integer :oral_comprehension_opi
      t.integer :basic_understanding_opi
      t.integer :introduction_to_print_opi
      t.integer :number_and_number_relations_opi
      t.integer :measurement_opi
      t.integer :geometry_and_spatial_sense_opi

      t.timestamps
    end
  end
end
