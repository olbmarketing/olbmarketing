class AddPhoneToStudents < ActiveRecord::Migration[5.0]
  def up 
    add_column :students, :phone1, :string
    add_column :students, :phone2, :string
  end
  def down 
    remove_column :students, :phone1, :string
    remove_column :students, :phone2, :string
  end
end
