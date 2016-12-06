class AddAddressToStudents < ActiveRecord::Migration[5.0]
  def up
    add_column :students, :address2, :string
    add_column :students, :city2, :string
    add_column :students, :state2, :string
    add_column :students, :zip2, :string
  end
  def down 
    remove_column :students, :address2, :string
    remove_column :students, :city2, :string
    remove_column :students, :state2, :string
    remove_column :students, :zip2, :string
  end 
end
