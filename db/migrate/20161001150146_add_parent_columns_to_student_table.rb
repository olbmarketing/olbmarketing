class AddParentColumnsToStudentTable < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :father_name, :string
    add_column :students, :mother_name, :string
    add_column :students, :address, :string
    add_column :students, :city, :string
    add_column :students, :state, :string
    add_column :students, :zip, :string
    add_column :students, :email1, :string
    add_column :students, :email2, :string
  end
end
