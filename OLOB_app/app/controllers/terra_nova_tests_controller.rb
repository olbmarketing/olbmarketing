class TerraNovaTestsController < ApplicationController
  before_action :set_terra_nova_test, only: [:show, :edit, :update, :destroy]

  # GET /terra_nova_tests
  # GET /terra_nova_tests.json
  def index
    @terra_nova_tests = TerraNovaTest.all
  end

  # GET /terra_nova_tests/1
  # GET /terra_nova_tests/1.json
  def show
  end

  # GET /terra_nova_tests/new
  def new
    @terra_nova_test = TerraNovaTest.new
  end

  # GET /terra_nova_tests/1/edit
  def edit
  end

  # POST /terra_nova_tests
  # POST /terra_nova_tests.json
  def create
    @terra_nova_test = TerraNovaTest.new(terra_nova_test_params)

    respond_to do |format|
      if @terra_nova_test.save
        format.html { redirect_to @terra_nova_test, notice: 'Terra nova test was successfully created.' }
        format.json { render :show, status: :created, location: @terra_nova_test }
      else
        format.html { render :new }
        format.json { render json: @terra_nova_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /terra_nova_tests/1
  # PATCH/PUT /terra_nova_tests/1.json
  def update
    respond_to do |format|
      if @terra_nova_test.update(terra_nova_test_params)
        format.html { redirect_to @terra_nova_test, notice: 'Terra nova test was successfully updated.' }
        format.json { render :show, status: :ok, location: @terra_nova_test }
      else
        format.html { render :edit }
        format.json { render json: @terra_nova_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /terra_nova_tests/1
  # DELETE /terra_nova_tests/1.json
  def destroy
    @terra_nova_test.destroy
    respond_to do |format|
      format.html { redirect_to terra_nova_tests_url, notice: 'Terra nova test was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_terra_nova_test
      @terra_nova_test = TerraNovaTest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def terra_nova_test_params
      params.require(:terra_nova_test).permit(:student_id, :test_date, :reading_scale_score, :reading_national_percentile, :oral_comprehension_opi, :oral_comprehension_level, :basic_understanding_opi, :basic_understanding_level, :introduction_to_print_opi, :introduction_to_print_level, :math_scale_score, :math_national_percentile, :number_and_number_relations_opi, :number_and_number_relations_level, :measurement_opi, :measurement_level, :geometry_and_spatial_sense_opi, :geometry_and_spatial_sense_level, :data_stats_and_probability_opi, :data_stats_and_probability_level)
    end
end
