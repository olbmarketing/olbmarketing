class AddKFirstToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :K_First, :string
  end
end
