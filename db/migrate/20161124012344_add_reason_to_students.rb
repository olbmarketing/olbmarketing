class AddReasonToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :reason, :string
  end
end
