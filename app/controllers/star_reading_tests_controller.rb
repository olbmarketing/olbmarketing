class StarReadingTestsController < ApplicationController
  before_action :set_star_reading_test, only: [:show, :edit, :update, :destroy]
  include Docx

  # GET /star_reading_tests
  # GET /star_reading_tests.json
  def index
    @student = Student.find(params[:student_id])
    if @student 
      @star_reading_tests = @student.star_reading_tests.order('test_date desc')
    else 
      @star_reading_tests = StarReadingTest.all
    end
  end

  # GET /star_reading_tests/1
  # GET /star_reading_tests/1.json
  def show
  end

  # GET /star_reading_tests/new
  def new
    student = Student.find(params[:student_id])
    @star_reading_test = StarReadingTest.new
    @star_reading_test.student = student
  end

  # GET /star_reading_tests/1/edit
  def edit
  end

  # POST /star_reading_tests
  # POST /star_reading_tests.json
  def create
    @star_reading_test = StarReadingTest.new(star_reading_test_params)

    respond_to do |format|
      if @star_reading_test.save
        format.html { redirect_to star_reading_tests_url(student_id: @star_reading_test.student.id), notice: 'Star reading test was successfully created.' }
        format.json { render :show, status: :created, location: @star_reading_test }
      else
        format.html { render :new }
        format.json { render json: @star_reading_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /star_reading_tests/1
  # PATCH/PUT /star_reading_tests/1.json
  def update
    respond_to do |format|
      if @star_reading_test.update(star_reading_test_params)
        format.html { redirect_to @star_reading_test, notice: 'Star reading test was successfully updated.' }
        format.json { render :show, status: :ok, location: @star_reading_test }
      else
        format.html { render :edit }
        format.json { render json: @star_reading_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /star_reading_tests/1
  # DELETE /star_reading_tests/1.json
  def destroy
    @star_reading_test.destroy
    respond_to do |format|
      format.html { redirect_to star_reading_tests_url(student_id: @star_reading_test.student.id), notice: 'Star reading test was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def download_report_docx
    @student = Student.find(params[:student_id])
    if @student 
      @star_reading_tests = @student.star_reading_tests.order('test_date desc')
    end 
    create_report(params[:gender])
    send_file(
      "#{Rails.root}/app/assets/STAR_testing/STAR_Reading_new.docx", 
      filename: "#{@student.get_first_name}_#{@student.last_name}_STAR_Reading.docx", 
      type: "application/docx"
    )
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_star_reading_test
      @star_reading_test = StarReadingTest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def star_reading_test_params
      params.require(:star_reading_test).permit(:student_id, :test_date, :scaled_score, :percentile_rank, :literature_key_ideas_and_details, :literature_craft_and_structure, :informational_text_key_ideas_and_details, :language_vocabulary_acquisition_and_use)
    end

    def create_report(gender)

      myz = Zip::File.open("#{Rails.root}/app/assets/STAR_testing/STAR_Reading_template.docx");

      xml_str = myz.read("word/charts/chart1.xml");
      chart_doc = Nokogiri::XML(xml_str);
      write_STAR_chart_doc(chart_doc, @star_reading_tests.reverse_order)

      main_doc = Nokogiri::XML(myz.read('word/document.xml'));
      write_main_doc(main_doc, gender)
      write_report_file(myz, [chart_doc], main_doc, "#{Rails.root}/app/assets/STAR_testing/STAR_Reading_new.docx")

    end 

    def write_main_doc (main_doc, gender)
      latest_score = (@star_reading_tests.to_a.sort_by!{|s|s.test_date}).last.scaled_score
      old_score = (@star_reading_tests.to_a.sort_by!{|s|s.test_date}).first.scaled_score
      first_name = @star_reading_tests.first.student.get_first_name
      last_name = @star_reading_tests.first.student.last_name 
      test_count = @star_reading_tests.count
      combine_splitted_wt(main_doc)

      write_STAR_main_doc_texts(main_doc, gender, test_count, latest_score, old_score, first_name, last_name)

      change_docx_text(main_doc, 'percentile_rank', "#{@star_reading_tests.first.percentile_rank}")

      remove_highlight main_doc
    end
end
