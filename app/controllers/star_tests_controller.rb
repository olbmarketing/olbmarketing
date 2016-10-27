require 'nokogiri'
require 'zip'
class StarTestsController < ApplicationController
  before_action :set_star_test, only: [:show, :edit, :update, :destroy]

  # GET /star_tests
  # GET /star_tests.json
  def index
    @student = Student.find(params[:student_id])
    if @student 
      @star_tests = @student.star_tests
    else 
      @star_tests = StarTest.all
    end 
    
  end

  # GET /star_tests/1
  # GET /star_tests/1.json
  def show
  end

  # GET /star_tests/new
  def new
    student = Student.find(params[:student_id])
    @star_test = StarTest.new
    @star_test.student = student
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
    student_id = @star_test.student.id
    @star_test.destroy
    respond_to do |format|
      format.html { redirect_to star_tests_url(student_id: @star_test.student.id), notice: 'Star test was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  # GET /star_tests/students
  def students
    @star_tests = StarTest.all
    @students = Student.all
  end

  # get 'star_tests/download_report_docx'
  def download_report_docx
    @student = Student.find(params[:student_id])
    if @student 
      @star_tests = @student.star_tests
    end 
    create_report
    send_file(
      "#{Rails.root}/app/assets/SATR_testing/new.docx", 
      filename: "#{@student.first_name}_#{@student.last_name}_STAR.docx", 
      type: "application/docx"
    )
  end

  # GET /star_test/report 
  def report
    @student = Student.find(params[:student_id])
    #@star_tests = StarTest.all
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_star_test
      @star_test = StarTest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def star_test_params
      params.require(:star_test).permit(:student_id, :test_date, :scaled_score, :developmental_stage, :alphabetic_principle, :concept_of_word, :visual_discrimination, :phonemic_awareness, :phonics, :structural_analysis, :vocabulary, :sentence_level_comprehension, :paragraph_level_comprehension, :early_numeracy)
    end

    def create_report 
      myz = Zip::File.open("#{Rails.root}/app/assets/SATR_testing/STAR_template.docx");
      xml_str = myz.read("word/charts/chart1.xml");
      chart_doc = Nokogiri::XML(xml_str);
      for i in 0...@star_tests.count 
        test = @star_tests[i]
        # only update test score for available test date count 
        if i < chart_doc.xpath('//c:ser').count 
          # set test date label 
          chart_doc.at_xpath("//c:ser[#{i+1}]/c:tx/c:strRef/c:strCache/c:pt/c:v").content = test.test_date.strftime('%m/%d/%Y')
          # get test categorys 
          test_category_array = []
          chart_doc.xpath("//c:ser[#{i+1}]/c:cat/c:strRef/c:strCache/c:pt/c:v").each do |node|
            # fix a typo in sample file 
            if node.content == "VS"
              node.content = "VD"
            end 
            test_category = node.content
            test_category_array << test_category
            
          end  
          # set test score 
          j = 0 # to be used to increment test categorys array 
          chart_doc.xpath("//c:ser[#{i+1}]/c:val/c:numRef/c:numCache/c:pt/c:v").each do |test_category_node|
            test_category_node.content = test[lookup_test_category(test_category_array[j])]
            j = j + 1
          end 

        end 
        
      end 
      # remove extra test dates (columns)
      if @star_tests.count < chart_doc.xpath('//c:ser').count 
        (chart_doc.xpath('//c:ser').count - @star_tests.count).times do 
          chart_doc.xpath('//c:ser').last.remove
        end 
      end 
      write_report_file(myz, chart_doc)

    end 

    def lookup_test_category(test_category_short)
      test_category_map = {'AP': 'alphabetic_principle', 'CW': 'concept_of_word', VD: 'visual_discrimination', PA: 'phonemic_awareness', PH: 'phonics', SA: 'structural_analysis', VO: 'vocabulary', SC: 'sentence_level_comprehension', PC: 'paragraph_level_comprehension', EN: 'early_numeracy'};
      test_category_map[test_category_short.to_sym]
    end 

    def write_report_file(zip_file, doc)
      # create buffer 
      document_file_path = 'word/document.xml'
      chart_file_path = "word/charts/chart1.xml"
      buffer = Zip::OutputStream.write_buffer do |out|
        zip_file.entries.each do |e|
          unless [chart_file_path].include?(e.name)
            out.put_next_entry(e.name)
            out.write e.get_input_stream.read
          end
        end

        #out.put_next_entry(DOCUMENT_FILE_PATH)
        #out.write replace["word/document.xml"]

        out.put_next_entry(chart_file_path)
        out.write doc.to_xml(:indent => 0).gsub("\n","")

        #out.put_next_entry(RELS_FILE_PATH)
        #out.write rels.to_xml(:indent => 0).gsub("\n","")
      end
      # write to file 
      File.open("#{Rails.root}/app/assets/SATR_testing/new.docx", "wb") {|f| f.write(buffer.string) }
    end 
end
