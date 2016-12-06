class CleanupEndingSpaces < ActiveRecord::Migration[5.0]
  def change
    Student.all.each do |s|
      s.school_year = s.school_year.strip if s.school_year
      s.first_name = s.first_name.strip if s.first_name
      s.last_name = s.last_name.strip if s.last_name
      s.new_or_return = s.new_or_return.strip if s.new_or_return
      s.student_class = s.student_class.strip if s.student_class
      s.catholic = s.catholic.strip if s.catholic
      s.parish = s.parish.strip if s.parish
      s.race = s.race.strip if s.race
      s.resides_with = s.resides_with.strip if s.resides_with
      s.reference_from = s.reference_from.strip if s.reference_from
      s.student_transfer = s.student_transfer.strip if s.student_transfer
      s.preK_to_K = s.preK_to_K.strip if s.preK_to_K
      s.father_name = s.father_name.strip if s.father_name
      s.mother_name = s.mother_name.strip if s.mother_name
      s.address = s.address.strip if s.address
      s.city = s.city.strip if s.city
      s.state = s.state.strip if s.state
      s.zip = s.zip.strip if s.zip
      s.email1 = s.email1.strip if s.email1
      s.email2 = s.email2.strip if s.email2
      s.save
    end 
  end
end
