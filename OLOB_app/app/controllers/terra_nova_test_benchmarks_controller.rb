class TerraNovaTestBenchmarksController < ApplicationController
  before_action :set_terra_nova_test_benchmark, only: [:show, :edit, :update, :destroy]

  # GET /terra_nova_test_benchmarks
  # GET /terra_nova_test_benchmarks.json
  def index
    @terra_nova_test_benchmarks = TerraNovaTestBenchmark.all
  end

  # GET /terra_nova_test_benchmarks/1
  # GET /terra_nova_test_benchmarks/1.json
  def show
  end

  # GET /terra_nova_test_benchmarks/new
  def new
    @terra_nova_test_benchmark = TerraNovaTestBenchmark.new
  end

  # GET /terra_nova_test_benchmarks/1/edit
  def edit
  end

  # POST /terra_nova_test_benchmarks
  # POST /terra_nova_test_benchmarks.json
  def create
    @terra_nova_test_benchmark = TerraNovaTestBenchmark.new(terra_nova_test_benchmark_params)

    respond_to do |format|
      if @terra_nova_test_benchmark.save
        format.html { redirect_to @terra_nova_test_benchmark, notice: 'Terra nova test benchmark was successfully created.' }
        format.json { render :show, status: :created, location: @terra_nova_test_benchmark }
      else
        format.html { render :new }
        format.json { render json: @terra_nova_test_benchmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /terra_nova_test_benchmarks/1
  # PATCH/PUT /terra_nova_test_benchmarks/1.json
  def update
    respond_to do |format|
      if @terra_nova_test_benchmark.update(terra_nova_test_benchmark_params)
        format.html { redirect_to @terra_nova_test_benchmark, notice: 'Terra nova test benchmark was successfully updated.' }
        format.json { render :show, status: :ok, location: @terra_nova_test_benchmark }
      else
        format.html { render :edit }
        format.json { render json: @terra_nova_test_benchmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /terra_nova_test_benchmarks/1
  # DELETE /terra_nova_test_benchmarks/1.json
  def destroy
    @terra_nova_test_benchmark.destroy
    respond_to do |format|
      format.html { redirect_to terra_nova_test_benchmarks_url, notice: 'Terra nova test benchmark was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_terra_nova_test_benchmark
      @terra_nova_test_benchmark = TerraNovaTestBenchmark.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def terra_nova_test_benchmark_params
      params.require(:terra_nova_test_benchmark).permit(:test_date, :oral_comprehension_opi, :basic_understanding_opi, :introduction_to_print_opi, :number_and_number_relations_opi, :measurement_opi, :geometry_and_spatial_sense_opi)
    end
end
