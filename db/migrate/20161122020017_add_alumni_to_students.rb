class AddAlumniToStudents < ActiveRecord::Migration[5.0]
  def up 
    add_column :students, :alumni, :boolean
  end
  def down 
    remove_column :students, :alumni, :boolean
  end
end
