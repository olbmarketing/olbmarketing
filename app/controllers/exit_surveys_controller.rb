class ExitSurveysController < ApplicationController
  before_action :set_exit_survey, only: [:show, :edit, :update, :destroy]

  # GET /exit_surveys
  # GET /exit_surveys.json
  def index
    @exit_surveys = ExitSurvey.all
  end

  # GET /exit_surveys/1
  # GET /exit_surveys/1.json
  def show
  end

  # GET /exit_surveys/new
  def new
    @exit_survey = ExitSurvey.new
  end

  # GET /exit_surveys/1/edit
  def edit
  end

  # POST /exit_surveys
  # POST /exit_surveys.json
  def create
    @exit_survey = ExitSurvey.new(exit_survey_params)

    respond_to do |format|
      if @exit_survey.save
        format.html { redirect_to @exit_survey, notice: 'Exit survey was successfully created.' }
        format.json { render :show, status: :created, location: @exit_survey }
      else
        format.html { render :new }
        format.json { render json: @exit_survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exit_surveys/1
  # PATCH/PUT /exit_surveys/1.json
  def update
    respond_to do |format|
      if @exit_survey.update(exit_survey_params)
        format.html { redirect_to @exit_survey, notice: 'Exit survey was successfully updated.' }
        format.json { render :show, status: :ok, location: @exit_survey }
      else
        format.html { render :edit }
        format.json { render json: @exit_survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exit_surveys/1
  # DELETE /exit_surveys/1.json
  def destroy
    @exit_survey.destroy
    respond_to do |format|
      format.html { redirect_to exit_surveys_url, notice: 'Exit survey was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exit_survey
      @exit_survey = ExitSurvey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exit_survey_params
      params.require(:exit_survey).permit(:student_id, :how_likely_to_recommend, :how_satisfied_with_education, :how_is_spiritual_environment, :spiritual_environment_comment, :how_is_physical_facilities, :physical_facilities_comment, :how_is_academic_program, :academic_program_comment, :how_is_social_environment, :social_environment_comment, :how_is_admin_faculty_and_staff, :admin_faculty_and_staff_comment, :how_is_communication, :communication_comment, :reason_for_leaving, :reason_for_leaving_explan, :comments_questions_concerns)
    end
end
