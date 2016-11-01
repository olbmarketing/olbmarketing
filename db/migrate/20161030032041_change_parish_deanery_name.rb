class ChangeParishDeaneryName < ActiveRecord::Migration[5.0]
  def up
    rename_column :parishes, :denery, :deanery
  end
  def down 
    rename_column :parishes, :deanery, :denery 
  end 
end
