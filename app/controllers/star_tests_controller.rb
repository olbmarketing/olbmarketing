require 'nokogiri'
require 'zip'
class StarTestsController < ApplicationController
  before_action :set_star_test, only: [:show, :edit, :update, :destroy]
  include Docx

  @@student_filter = ['amprek', 'pmprek', 'k', 'pm prek']

  @@star_test_disp_col_names = StarTest.attribute_names - ['id', 'student_id', 'created_at', 'updated_at']

  # GET /star_tests
  # GET /star_tests.json
  def index
    @student = Student.find(params[:student_id])
    if @student 
      @star_tests = @student.star_tests.order('test_date desc')
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
        format.html { redirect_to star_tests_url(student_id: @star_test.student.id), notice: 'Star test was successfully created.' }
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
    current_school_year = Student.get_school_year(Time.now)
    # since only students of certain classes take star tests 
    student_filter = @@student_filter
    if params[:school_year]
      @school_year = params[:school_year]
      @students = Student.where('lower(student_class) in (?)', student_filter).where(school_year: @school_year).order('last_name')
    else 
      @students = Student.where('lower(student_class) in (?)', student_filter).where(school_year: current_school_year).order('last_name')
    end 
    
    
  end

  # get 'star_tests/download_report_docx'
  def download_report_docx
    @student = Student.find(params[:student_id])
    if @student 
      @star_tests = @student.star_tests.order('test_date')
    end 
    create_report(params[:gender])
    send_file(
      "#{Rails.root}/app/assets/STAR_testing/STAR_Literacy_new.docx", 
      filename: "#{@student.get_first_name}_#{@student.last_name}_STAR_Literacy.docx", 
      type: "application/docx"
    )
  end

  # GET /star_test/report 
  def report
    @student = Student.find(params[:student_id])
    #@star_tests = StarTest.all
  end 

  # GET /star_tests/all_star_literarcy_download 
  def all_star_literarcy_download
    #File.open('app/assets/STAR_testing/star_literarcy_all.zip', 'w')
    folder = "app/assets/STAR_testing/star_literarcy_all"
    zipfile_name = folder + '.zip'
    if !File.directory?(folder)
      Dir.mkdir folder
    else 
      Dir[folder + '/*'].each do |file_path|
        File.delete file_path
      end 
    end 
    if File.exist? zipfile_name 
      File.delete zipfile_name
    end 
    school_year = params[:school_year] ? params[:school_year] : Student.get_school_year(Time.now)
    Student.get_students_by_sy(school_year).where('lower(student_class) in (?)', @@student_filter).each do |student|
      @star_tests = student.star_tests.order('test_date')
      if @star_tests.count > 0 
        create_report(student.gender, "#{Rails.root}/#{folder}/#{student.get_first_name}_#{student.last_name}.docx")
      end
    end 
    input_filenames = Dir["#{Rails.root}/#{folder}" + '/*']
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      input_filenames.each do |filename|
        zipfile.add(File.basename(filename), filename)
      end
      if input_filenames.count == 0 
        zipfile.get_output_stream("No_Test_Found") { |f| f.write "No test found for this school year" }
      end 
    end
    #File.delete 'app/assets/STAR_testing/abc.zip'
    send_file(
      "#{Rails.root}/app/assets/STAR_testing/star_literarcy_all.zip", 
      filename: "star_literarcy_all.zip", 
      type: 'application/zip'
    )
  end 

  # GET /star_tests/star_test_csv_by_student 
  def star_test_csv_by_student
    student = Student.find(params[:student_id])
    csv_str = CSV.generate do |csv|
      attr_names = ['first_name', 'last_name'] + @@star_test_disp_col_names
      csv << attr_names
      # get previous year student 
      prev_sy_student = student.get_prev_year_student
      if prev_sy_student
        prev_sy_student.star_tests.order('test_date').each do |st|
          my_attributes = st.attributes.select {|k, v|  @@star_test_disp_col_names.include?(k)}
          csv << [prev_sy_student.first_name, prev_sy_student.last_name] + my_attributes.values
        end
      end 
      # get current year student 
      @star_tests = student.star_tests.order('test_date')
      @star_tests.each do |st|
        my_attributes = st.attributes.select {|k, v|  @@star_test_disp_col_names.include?(k)}
        csv << [student.first_name, student.last_name] + my_attributes.values
      end 
      
    end 

    respond_to do |format|
      format.all  { send_data csv_str, filename: "#{student.first_name}_#{student.last_name}_star_tests.csv" }
    end
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

    def create_report(gender, location = nil)
      myz = Zip::File.open("#{Rails.root}/app/assets/STAR_testing/STAR_template.docx");
      xml_str = myz.read("word/charts/chart1.xml");
      chart_doc = Nokogiri::XML(xml_str);
      write_chart_doc(chart_doc)
      main_doc = Nokogiri::XML(myz.read('word/document.xml'));
      write_main_doc(main_doc, gender)
      if location 
        write_report_file(myz, [chart_doc], main_doc, location)
      else 
        write_report_file(myz, [chart_doc], main_doc, "#{Rails.root}/app/assets/STAR_testing/STAR_Literacy_new.docx")
      end

    end 

    def lookup_test_category(test_category_short)
      test_category_map = {'AP': 'alphabetic_principle', 'CW': 'concept_of_word', VD: 'visual_discrimination', PA: 'phonemic_awareness', PH: 'phonics', SA: 'structural_analysis', VO: 'vocabulary', SC: 'sentence_level_comprehension', PC: 'paragraph_level_comprehension', EN: 'early_numeracy'};
      test_category_map[test_category_short.to_sym]
    end 

    def write_chart_doc (chart_doc)
      first_name = @star_tests.first.student.get_first_name
      last_name = @star_tests.first.student.last_name
      # update Child name in chart 
      change_docx_text(chart_doc, "Child name", "#{first_name} #{last_name}", "a:t")
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
      # fix order tag 
      fix_order_tag chart_doc
    end

    def write_main_doc (main_doc, gender)
      latest_score = (@star_tests.to_a.sort_by!{|s|s.test_date}).last.scaled_score
      old_score = (@star_tests.to_a.sort_by!{|s|s.test_date}).first.scaled_score
      first_name = @star_tests.first.student.get_first_name
      last_name = @star_tests.first.student.last_name 

      combine_splitted_wt(main_doc)
      remove_extra_stage_text(main_doc, latest_score)
      test_count = @star_tests.count

      write_STAR_main_doc_texts(main_doc, gender, test_count, latest_score, old_score, first_name, last_name)
      # change stage 
      change_docx_text(main_doc, 'v_stage', get_stage(latest_score))
      change_docx_text(main_doc, 'v_reader', get_reader(latest_score))

      remove_highlight main_doc
    end

    def remove_extra_stage_text(main_doc, score)
      stage_text = get_stage(score)
      node_set = main_doc.xpath("//w:t[contains(text(), 'Reader_Stage_p')]")
      node_set.each do |t|
        # if the paragraph tag is not the correct stage, then remove it 
        if !t.content.include?(stage_text.gsub(' ', '_'))
          # remove the whole paragraph 
          t.parent.parent.remove
        else 
          t.content = "" # remove paragraph tag 
        end 
      end 
      # remove extra empty paragraph
      node_set = main_doc.xpath("//w:p")
      node_set.each do |p|
        if p.children.count == 1 && p.next_element.children.count == 1
          p.remove
        end 
      end 
    end 

    def get_stage(score)
      get_reader(score) + " Stage"
    end 

    def get_reader(score)
      result = ''
      if score >= 300 && score <= 487
        result = 'Early Emergent Reader'
      elsif score >= 488 && score <= 674
        result = 'Late Emergent Reader'
      elsif score >= 675 && score <= 774
        result = 'Transitional Reader'
      else 
        result = 'Probable Reader'
      end  
      result
    end 

end
