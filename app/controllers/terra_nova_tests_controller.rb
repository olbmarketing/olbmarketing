class TerraNovaTestsController < ApplicationController
  before_action :set_terra_nova_test, only: [:show, :edit, :update, :destroy]
  include Docx

  # GET /terra_nova_tests
  # GET /terra_nova_tests.json
  def index
    @student = Student.find(params[:student_id])
    if @student 
      @terra_nova_tests = @student.terra_nova_tests
    else 
      @terra_nova_tests = TerraNovaTest.all
    end 
  end

  # GET /terra_nova_tests/1
  # GET /terra_nova_tests/1.json
  def show
  end

  # GET /terra_nova_tests/new
  def new
    student = Student.find(params[:student_id])
    @terra_nova_test = TerraNovaTest.new
    @terra_nova_test.student = student
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
      format.html { redirect_to terra_nova_tests_url(student_id: @terra_nova_test.student.id), notice: 'Terra nova test was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  # get 'star_tests/download_report_docx'
  def download_report_docx
    @student = Student.find(params[:student_id])
    if @student 
      @star_tests = @student.star_tests
    end 
    create_report
    send_file(
      "#{Rails.root}/app/assets/Terra_Nova_testing/new.docx", 
      filename: "#{@student.first_name}_#{@student.last_name}_Terra_Nova.docx", 
      type: "application/docx"
    )
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_terra_nova_test
      @terra_nova_test = TerraNovaTest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def terra_nova_test_params
      params.require(:terra_nova_test).permit(:student_id, :test_date, :reading_scale_score, :reading_national_percentile, :oral_comprehension_opi, :basic_understanding_opi, :introduction_to_print_opi, :math_scale_score, :math_national_percentile, :number_and_number_relations_opi, :measurement_opi, :geometry_and_spatial_sense_opi, :data_stats_and_probability_opi)
    end

    def create_report
      myz = Zip::File.open("#{Rails.root}/app/assets/Terra_Nova_testing/Terra_Nova_template.docx");
      chart_doc1 = Nokogiri::XML(myz.read("word/charts/chart1.xml"););
      chart_doc2 = Nokogiri::XML(myz.read("word/charts/chart2.xml"););
      write_chart_doc1(chart_doc1)
      write_chart_doc2(chart_doc2)
      main_doc = Nokogiri::XML(myz.read('word/document.xml'));
      write_main_doc(main_doc)
      write_report_file(myz, [chart_doc], main_doc, "#{Rails.root}/app/assets/Terra_Nova_testing/new.docx")

    end
    
    def write_chart_doc1(chart_doc1)

    end 

    def write_chart_doc1(chart_doc2)

    end 

    def write_main_doc(main_doc)

    end 

end
