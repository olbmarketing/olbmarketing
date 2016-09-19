class CreateStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.integer :school_year
      t.string :new_or_return
      t.string :class
      t.string :catholic
      t.string :parish
      t.string :race
      t.string :resides_with
      t.string :reference_from
      t.string :student_transfer
      t.string :preK_to_K

      t.timestamps
    end
  end
end
