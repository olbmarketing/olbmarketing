class AddNoteToParishes < ActiveRecord::Migration[5.0]
  def up 
    add_column :parishes, :note, :text
  end
  def down 
    remove_column :parishes, :note, :text
  end
end
