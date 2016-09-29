class StarTestsController < ApplicationController
  before_action :set_star_test, only: [:show, :edit, :update, :destroy]

  # GET /star_tests
  # GET /star_tests.json
  def index
    @star_tests = StarTest.all
  end

  # GET /star_tests/1
  # GET /star_tests/1.json
  def show
  end

  # GET /star_tests/new
  def new
    @star_test = StarTest.new
  end

  # GET /star_tests/1/edit
  def edit
  end

  # POST /star_tests
  # POST /star_tests.json
  def create
    @star_test = StarTest.new(star_test_params)

    respond_to do |format|
      if @star_test.save
        format.html { redirect_to @star_test, notice: 'Star test was successfully created.' }
        format.json { render :show, status: :created, location: @star_test }
      else
        format.html { render :new }
        format.json { render json: @star_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /star_tests/1
  # PATCH/PUT /star_tests/1.json
  def update
    respond_to do |format|
      if @star_test.update(star_test_params)
        format.html { redirect_to @star_test, notice: 'Star test was successfully updated.' }
        format.json { render :show, status: :ok, location: @star_test }
      else
        format.html { render :edit }
        format.json { render json: @star_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /star_tests/1
  # DELETE /star_tests/1.json
  def destroy
    @star_test.destroy
    respond_to do |format|
      format.html { redirect_to star_tests_url, notice: 'Star test was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_star_test
      @star_test = StarTest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def star_test_params
      params.require(:star_test).permit(:first_name, :, :last_name, :, :test_date, :, :scaled_score, :, :developmental_stage, :, :alphabetic_principle, :, :concept_of_word, :, :visual_discrimination, :, :phonemic_awareness, :, :phonics, :, :structural_analysis, :, :vocabulary, :, :sentence_level_comprehension, :, :paragraph_level_comprehension, :, :early_numeracy, :)
    end
end
