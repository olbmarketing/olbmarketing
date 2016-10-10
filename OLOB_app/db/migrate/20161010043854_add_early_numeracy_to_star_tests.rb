class AddEarlyNumeracyToStarTests < ActiveRecord::Migration[5.0]
  def change
    add_column :star_tests, :early_numeracy, :integer
  end
end
