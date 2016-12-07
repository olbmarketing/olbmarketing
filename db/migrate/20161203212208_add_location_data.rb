class AddLocationData < ActiveRecord::Migration[5.0]
  def up
    change_table :students do |t|
      t.float :latitude
      t.float :longitude
    end
    Student.find_each do |student|
      student.valid?
      student.save
      sleep 1
    end
    change_table :parishes do |t|
      t.float :latitude
      t.float :longitude
    end
    Parish.find_each do |parish|
      parish.valid?
      parish.save
      sleep 1
    end
  end

  def down
    change_table :students do |t|
      t.remove :latitude, :longitude
    end
    change_table :parishes do |t|
      t.remove :latitude, :longitude
    end
  end
end
