class CreateStarTests < ActiveRecord::Migration[5.0]
  def change
    create_table :star_tests do |t|
      t.string :first_name
      t.string :last_name
      t.string :test_date
      t.string :scaled_score
      t.string :developmental_stage
      t.string :alphabetic_principle
      t.string :concept_of_word
      t.string :visual_discrimination
      t.string :phonemic_awareness
      t.string :phonics
      t.string :structural_analysis
      t.string :vocabulary
      t.string :sentence_level_comprehension
      t.string :paragraph_level_comprehension
      t.string :early_numeracy

      t.timestamps
    end
  end
end
