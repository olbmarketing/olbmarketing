class CreateStarMathTests < ActiveRecord::Migration[5.0]
  def change
    create_table :star_math_tests do |t|
      t.belongs_to :student, foreign_key: true
      t.date :test_date
      t.integer :scaled_score
      t.integer :numbers_and_operations
      t.integer :algebra
      t.integer :measurement_and_data
      t.integer :geometry

      t.timestamps
    end
  end
end
