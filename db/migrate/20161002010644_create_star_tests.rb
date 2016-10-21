class CreateStarTests < ActiveRecord::Migration[5.0]
  def change
    create_table :star_tests do |t|
      t.belongs_to :student, foreign_key: true
      t.date :test_date
      t.integer :scaled_score
      t.string :developmental_stage
      t.integer :alphabetic_principle
      t.integer :concept_of_word
      t.integer :visual_discrimination
      t.integer :phonemic_awareness
      t.integer :phonics
      t.integer :structural_analysis
      t.integer :vocabulary
      t.integer :sentence_level_comprehension
      t.integer :paragraph_level_comprehension

      t.timestamps
    end
  end
end
