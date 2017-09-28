class TerraNovaTestsController < ApplicationController
  before_action :set_terra_nova_test, only: [:show, :edit, :update, :destroy]
  include Docx

  # GET /terra_nova_tests
  # GET /terra_nova_tests.json
  def index
    @student = Student.find(params[:student_id])
    if @student 
      @terra_nova_tests = @student.terra_nova_tests.order('test_date desc')
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
      @terra_nova_test = @student.terra_nova_tests.where(id: params[:terra_nova_test_id]).first
    end 
    create_report(params[:gender])
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

    def create_report(gender)
      zip_path = "#{Rails.root}/app/assets/Terra_Nova_testing/Terra_Nova_Template.docx"
      output_path = "#{Rails.root}/app/assets/Terra_Nova_testing/new.docx"
      myz = Zip::File.open(zip_path);
      chart_doc1 = Nokogiri::XML(myz.read("word/charts/chart1.xml"));
      chart_doc2 = Nokogiri::XML(myz.read("word/charts/chart2.xml"));
      write_chart_doc1(chart_doc1)
      write_chart_doc2(chart_doc2)
      main_doc = Nokogiri::XML(myz.read('word/document.xml'));
      write_main_doc(main_doc, gender)
      write_report_file(myz, [chart_doc1, chart_doc2], main_doc, output_path)

    end
    
    def write_chart_doc1(chart_doc1)
      # update student name in chart 
      first_name = @terra_nova_test.student.get_first_name
      last_name = @terra_nova_test.student.last_name
      change_docx_text(chart_doc1, "Student Name", "#{first_name} #{last_name}", "a:t")

      bar_chart = chart_doc1.at_xpath('//c:barChart')
      line_chart = chart_doc1.at_xpath('//c:lineChart')
      bar_chart_values = bar_chart.at_xpath('.//c:ser').at_xpath('.//c:val').xpath('.//c:v')
      bar_chart_values[0].content = @terra_nova_test.oral_comprehension_opi
      bar_chart_values[1].content = @terra_nova_test.basic_understanding_opi
      bar_chart_values[2].content = @terra_nova_test.introduction_to_print_opi
      line_chart_values = line_chart.at_xpath('.//c:ser').at_xpath('.//c:val').xpath('.//c:v')
      line_chart_values[0].content = @terra_nova_test.get_national_opi :oral_comprehension_opi
      line_chart_values[1].content = @terra_nova_test.get_national_opi :basic_understanding_opi
      line_chart_values[2].content = @terra_nova_test.get_national_opi :introduction_to_print_opi
    end 

    def write_chart_doc2(chart_doc2)
      # update student name in chart 
      first_name = @terra_nova_test.student.get_first_name
      last_name = @terra_nova_test.student.last_name
      change_docx_text(chart_doc2, "Student Name", "#{first_name} #{last_name}", "a:t")
      bar_chart = chart_doc2.at_xpath('//c:barChart')
      line_chart = chart_doc2.at_xpath('//c:lineChart')
      bar_chart_values = bar_chart.at_xpath('.//c:ser').at_xpath('.//c:val').xpath('.//c:v')
      bar_chart_values[0].content = @terra_nova_test.number_and_number_relations_opi
      bar_chart_values[1].content = @terra_nova_test.measurement_opi
      bar_chart_values[2].content = @terra_nova_test.geometry_and_spatial_sense_opi
      bar_chart_values[3].content = @terra_nova_test.data_stats_and_probability_opi
      line_chart_values = line_chart.at_xpath('.//c:ser').at_xpath('.//c:val').xpath('.//c:v')
      line_chart_values[0].content = @terra_nova_test.get_national_opi :number_and_number_relations_opi
      line_chart_values[1].content = @terra_nova_test.get_national_opi :measurement_opi
      line_chart_values[2].content = @terra_nova_test.get_national_opi :geometry_and_spatial_sense_opi
      line_chart_values[3].content = @terra_nova_test.get_national_opi :data_stats_and_probability_opi
    end 

    def write_main_doc(main_doc, gender)

      first_name = @terra_nova_test.student.get_first_name
      last_name = @terra_nova_test.student.last_name
      reading_scale_score = @terra_nova_test.reading_scale_score
      math_scale_score = @terra_nova_test.math_scale_score
      reading_national_percentile = @terra_nova_test.reading_national_percentile
      math_national_percentile = @terra_nova_test.math_national_percentile
      oral_comprehension_opi = @terra_nova_test.oral_comprehension_opi
      basic_understanding_opi = @terra_nova_test.basic_understanding_opi
      introduction_to_print_opi = @terra_nova_test.introduction_to_print_opi
      number_and_number_relations_opi = @terra_nova_test.number_and_number_relations_opi
      measurement_opi = @terra_nova_test.measurement_opi 
      geometry_and_spatial_sense_opi = @terra_nova_test.geometry_and_spatial_sense_opi
      data_stats_and_probability_opi = @terra_nova_test.data_stats_and_probability_opi
      oc_national_opi = @terra_nova_test.get_national_opi(:oral_comprehension_opi)
      bu_national_opi = @terra_nova_test.get_national_opi(:basic_understanding_opi)
      ip_national_opi = @terra_nova_test.get_national_opi(:introduction_to_print_opi)
      nn_national_opi = @terra_nova_test.get_national_opi(:number_and_number_relations_opi)
      me_national_opi = @terra_nova_test.get_national_opi(:measurement_opi)
      gs_national_opi = @terra_nova_test.get_national_opi(:geometry_and_spatial_sense_opi)
      dp_national_opi = @terra_nova_test.get_national_opi(:data_stats_and_probability_opi)
      oc_range = @terra_nova_test.get_opi_range(:oral_comprehension_opi)
      bu_range = @terra_nova_test.get_opi_range(:basic_understanding_opi)
      ip_range = @terra_nova_test.get_opi_range(:introduction_to_print_opi)
      nn_range = @terra_nova_test.get_opi_range(:number_and_number_relations_opi)
      me_range = @terra_nova_test.get_opi_range(:measurement_opi)
      gs_range = @terra_nova_test.get_opi_range(:geometry_and_spatial_sense_opi)
      dp_range = @terra_nova_test.get_opi_range(:data_stats_and_probability_opi)
      oc_mastery = @terra_nova_test.get_opi_mastery(:oral_comprehension_opi)
      bu_mastery = @terra_nova_test.get_opi_mastery(:basic_understanding_opi)
      ip_mastery = @terra_nova_test.get_opi_mastery(:introduction_to_print_opi)
      nn_mastery = @terra_nova_test.get_opi_mastery(:number_and_number_relations_opi)
      me_mastery = @terra_nova_test.get_opi_mastery(:measurement_opi)
      gs_mastery = @terra_nova_test.get_opi_mastery(:geometry_and_spatial_sense_opi)
      dp_mastery = @terra_nova_test.get_opi_mastery(:data_stats_and_probability_opi)

      combine_splitted_wt(main_doc)

      change_docx_text(main_doc, 'child_name_full', "#{first_name} #{last_name}")
      change_docx_text(main_doc, 'child_name', "#{first_name}")
      change_docx_text(main_doc, 'reading_scale_score', "#{reading_scale_score}")
      replace_superscript(main_doc, reading_national_percentile.ordinalize[-2..-1])
      change_docx_text(main_doc, 'math_scale_score', "#{math_scale_score}")
      change_docx_text(main_doc, 'reading_national_percentileth', "#{reading_national_percentile}")
      change_docx_text(main_doc, 'reading_national_percentile', "#{reading_national_percentile}")
      change_docx_text(main_doc, 'math_national_percentile', "#{math_national_percentile}")

      # change student opi variables in table 
      change_docx_text(main_doc, 'oc_opi', "#{oral_comprehension_opi}")
      change_docx_text(main_doc, 'bu_opi', "#{basic_understanding_opi}")
      change_docx_text(main_doc, 'ip_opi', "#{introduction_to_print_opi}")
      change_docx_text(main_doc, 'oc_opi', "#{oral_comprehension_opi}")
      change_docx_text(main_doc, 'nn_opi', "#{number_and_number_relations_opi}")
      change_docx_text(main_doc, 'me_opi', "#{measurement_opi}")
      change_docx_text(main_doc, 'gs_opi', "#{geometry_and_spatial_sense_opi}")
      change_docx_text(main_doc, 'dp_opi', "#{data_stats_and_probability_opi}")

      # change national opi variables in table 
      change_docx_text(main_doc, 'oc_national_opi', "#{oc_national_opi}")
      change_docx_text(main_doc, 'bu_national_opi', "#{bu_national_opi}")
      change_docx_text(main_doc, 'ip_national_opi', "#{ip_national_opi}")
      change_docx_text(main_doc, 'oc_national_opi', "#{oc_national_opi}")
      change_docx_text(main_doc, 'nn_national_opi', "#{nn_national_opi}")
      change_docx_text(main_doc, 'me_national_opi', "#{me_national_opi}")
      change_docx_text(main_doc, 'gs_national_opi', "#{gs_national_opi}")
      change_docx_text(main_doc, 'dp_national_opi', "#{dp_national_opi}")

      # change opi range variables in table 
      change_docx_text(main_doc, 'oc_range', "#{oc_range}")
      change_docx_text(main_doc, 'bu_range', "#{bu_range}")
      change_docx_text(main_doc, 'ip_range', "#{ip_range}")
      change_docx_text(main_doc, 'nn_range', "#{nn_range}")
      change_docx_text(main_doc, 'me_range', "#{me_range}")
      change_docx_text(main_doc, 'gs_range', "#{gs_range}")
      change_docx_text(main_doc, 'dp_range', "#{dp_range}")

      # change opi mastery variables in table 
      change_docx_text(main_doc, 'oc_mastery', "#{oc_mastery}")
      change_docx_text(main_doc, 'bu_mastery', "#{bu_mastery}")
      change_docx_text(main_doc, 'ip_mastery', "#{ip_mastery}")
      change_docx_text(main_doc, 'nn_mastery', "#{nn_mastery}")
      change_docx_text(main_doc, 'me_mastery', "#{me_mastery}")
      change_docx_text(main_doc, 'gs_mastery', "#{gs_mastery}")
      change_docx_text(main_doc, 'dp_mastery', "#{dp_mastery}")

      change_gender gender, main_doc
      
    end 

end
