class CreateExitSurveys < ActiveRecord::Migration[5.0]
  def change
    create_table :exit_surveys do |t|
      t.belongs_to :student, foreign_key: true
      t.string :how_likely_to_recommend
      t.string :how_satisfied_with_education
      t.string :how_is_spiritual_environment
      t.string :spiritual_environment_comment
      t.string :how_is_physical_facilities
      t.string :physical_facilities_comment
      t.string :how_is_academic_program
      t.string :academic_program_comment
      t.string :how_is_social_environment
      t.string :social_environment_comment
      t.string :how_is_admin_faculty_and_staff
      t.string :admin_faculty_and_staff_comment
      t.string :how_is_communication
      t.string :communication_comment
      t.string :reason_for_leaving
      t.string :reason_for_leaving_explan
      t.string :comments_questions_concerns

      t.timestamps
    end
  end
end
