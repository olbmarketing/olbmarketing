class CreateSchools < ActiveRecord::Migration[5.0]
  def change
    create_table :schools do |t|
      t.string :name
      t.string :phone
      t.string :fax
      t.string :email
      t.string :website
      t.belongs_to :parish, foreign_key: true
      t.string :address
      t.string :city
      t.string :state
      t.string :zip

      t.timestamps
    end
  end
end
