class ChangeSchoolYearDatatypeInStudentTable < ActiveRecord::Migration[5.0]
  def up
    change_column :students, :school_year, :integer
  end
  def down 
    change_column :students, :school_year, :string 
  end 
end
