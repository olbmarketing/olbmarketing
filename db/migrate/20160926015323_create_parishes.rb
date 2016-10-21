class CreateParishes < ActiveRecord::Migration[5.0]
  def change
    create_table :parishes do |t|
      t.string :name
      t.string :contact
      t.string :phone
      t.string :fax
      t.string :email
      t.string :website
      t.string :denery
      t.string :address
      t.string :city
      t.string :state
      t.string :zip

      t.timestamps
    end
  end
end
