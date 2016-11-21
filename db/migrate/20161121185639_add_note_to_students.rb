class AddNoteToStudents < ActiveRecord::Migration[5.0]
  def up
    add_column :students, :note, :text
  end
  def down
    remove_column :students, :note, :text
  end
end
