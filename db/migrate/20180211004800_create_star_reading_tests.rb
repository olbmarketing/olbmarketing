class CreateStarReadingTests < ActiveRecord::Migration[5.1]
  def change
    create_table :star_reading_tests do |t|
      t.belongs_to :student, foreign_key: true
      t.date :test_date
      t.integer :scaled_score
      t.integer :percentile_rank
      t.integer :literature_key_ideas_and_details
      t.integer :literature_craft_and_structure
      t.integer :informational_text_key_ideas_and_details
      t.integer :language_vocabulary_acquisition_and_use

      t.timestamps
    end
  end
end
