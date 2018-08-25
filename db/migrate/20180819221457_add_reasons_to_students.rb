class AddReasonsToStudents < ActiveRecord::Migration[5.1]
  def up
    add_column :students, :reason_new_or_return , :string
    add_column :students, :toddler_to_ttt , :string
    add_column :students, :ttt_to_ps , :string
    add_column :students, :reason_ttt_to_ps , :string
    add_column :students, :ps_to_prek , :string
    add_column :students, :reason_ps_to_prek , :string
    add_column :students, :reason_prek_to_k , :string
  end
  def down
    remove_column :students, :reason_new_or_return , :string
    remove_column :students, :toddler_to_ttt , :string
    remove_column :students, :ttt_to_ps , :string
    remove_column :students, :reason_ttt_to_ps , :string
    remove_column :students, :ps_to_prek , :string
    remove_column :students, :reason_ps_to_prek , :string
    remove_column :students, :reason_prek_to_k , :string
  end
end
