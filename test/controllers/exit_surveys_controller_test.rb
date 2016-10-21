require 'test_helper'

class ExitSurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @exit_survey = exit_surveys(:one)
  end

  test "should get index" do
    get exit_surveys_url
    assert_response :success
  end

  test "should get new" do
    get new_exit_survey_url
    assert_response :success
  end

  test "should create exit_survey" do
    assert_difference('ExitSurvey.count') do
      post exit_surveys_url, params: { exit_survey: { academic_program_comment: @exit_survey.academic_program_comment, admin_faculty_and_staff_comment: @exit_survey.admin_faculty_and_staff_comment, comments_questions_concerns: @exit_survey.comments_questions_concerns, communication_comment: @exit_survey.communication_comment, how_is_academic_program: @exit_survey.how_is_academic_program, how_is_admin_faculty_and_staff: @exit_survey.how_is_admin_faculty_and_staff, how_is_communication: @exit_survey.how_is_communication, how_is_physical_facilities: @exit_survey.how_is_physical_facilities, how_is_social_environment: @exit_survey.how_is_social_environment, how_is_spiritual_environment: @exit_survey.how_is_spiritual_environment, how_likely_to_recommend: @exit_survey.how_likely_to_recommend, how_satisfied_with_education: @exit_survey.how_satisfied_with_education, physical_facilities_comment: @exit_survey.physical_facilities_comment, reason_for_leaving: @exit_survey.reason_for_leaving, reason_for_leaving_explan: @exit_survey.reason_for_leaving_explan, social_environment_comment: @exit_survey.social_environment_comment, spiritual_environment_comment: @exit_survey.spiritual_environment_comment, student_id: @exit_survey.student_id } }
    end

    assert_redirected_to exit_survey_url(ExitSurvey.last)
  end

  test "should show exit_survey" do
    get exit_survey_url(@exit_survey)
    assert_response :success
  end

  test "should get edit" do
    get edit_exit_survey_url(@exit_survey)
    assert_response :success
  end

  test "should update exit_survey" do
    patch exit_survey_url(@exit_survey), params: { exit_survey: { academic_program_comment: @exit_survey.academic_program_comment, admin_faculty_and_staff_comment: @exit_survey.admin_faculty_and_staff_comment, comments_questions_concerns: @exit_survey.comments_questions_concerns, communication_comment: @exit_survey.communication_comment, how_is_academic_program: @exit_survey.how_is_academic_program, how_is_admin_faculty_and_staff: @exit_survey.how_is_admin_faculty_and_staff, how_is_communication: @exit_survey.how_is_communication, how_is_physical_facilities: @exit_survey.how_is_physical_facilities, how_is_social_environment: @exit_survey.how_is_social_environment, how_is_spiritual_environment: @exit_survey.how_is_spiritual_environment, how_likely_to_recommend: @exit_survey.how_likely_to_recommend, how_satisfied_with_education: @exit_survey.how_satisfied_with_education, physical_facilities_comment: @exit_survey.physical_facilities_comment, reason_for_leaving: @exit_survey.reason_for_leaving, reason_for_leaving_explan: @exit_survey.reason_for_leaving_explan, social_environment_comment: @exit_survey.social_environment_comment, spiritual_environment_comment: @exit_survey.spiritual_environment_comment, student_id: @exit_survey.student_id } }
    assert_redirected_to exit_survey_url(@exit_survey)
  end

  test "should destroy exit_survey" do
    assert_difference('ExitSurvey.count', -1) do
      delete exit_survey_url(@exit_survey)
    end

    assert_redirected_to exit_surveys_url
  end
end
