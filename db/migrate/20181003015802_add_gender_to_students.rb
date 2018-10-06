class AddGenderToStudents < ActiveRecord::Migration[5.1]
  def up
    add_column :students, :gender, :string
  end
  def down
    remove_column :students, :gender, :string
  end
end
