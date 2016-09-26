class ChangeSchoolYearDatatypeInStudentTableV2 < ActiveRecord::Migration[5.0]
  def change
    change_column :students, :school_year, :string
  end
end
