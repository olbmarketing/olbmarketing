class RenameStudentsClassColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :students, :class, :student_class
  end
end
