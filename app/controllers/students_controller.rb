class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  @@valid_column_names = Student.get_valid_fields

  # GET /students
  # GET /students.json
  def index
    @valid_fields = @@valid_column_names 
    @display_fields = Student.get_display_fields
    if params[:school_year]
      @students = Student.where(school_year: params[:school_year])
      @school_year = params[:school_year]
    else 
      # only show current year student by default 
      current_school_year = Student.get_school_year(Time.now)
      @students = Student.where(school_year: current_school_year)
      @school_year = current_school_year
    end 
    #@students = Student.all
    respond_to do |format|
      format.html
      format.xls {
        filename = "#{@school_year}_students"
        response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '.xls"'
        render 
      }
      format.csv {
        send_data @students.to_csv
      }
    end
  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to '/students', notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def import
    my_csv = Student.get_csv_from_file params[:file]
    # process csv to remove unidentified columns
    removed_columns = remove_extra_columns_for_csv my_csv
    remove_column_rows my_csv
    students_from_file = Student.get_students_from_csv my_csv

    all_valid = true
    insert_count = 0 
    update_count = 0 
    insert_students = []
    update_students = []
    @upload_errors = []
    @@abc = 'hello_abc'
    @notice_array = ['abc']
    # check for errors before insert data
    students_from_file.each_with_index do |s, index|
      # check if duplicate with other studnents from file 
      ((index + 1)..(students_from_file.count - 1)).each do |i|
        s2 = students_from_file[i]
        if s.first_name == s2.first_name && s.last_name == s2.last_name && s.school_year == s2.school_year
          all_valid = false
          error_msg = "Duplicate students in data source: student at row #{index + 2} and student at row #{i + 2} have the same first_name, last_name, school_year"
          @upload_errors << error_msg
          break
        end 
      end 
      # check if insert or update 
      query_result = Student.where('first_name = ? AND last_name = ? AND school_year = ?', s.first_name, s.last_name, s.school_year)
      if query_result.count > 0 # if update 
        if query_result.count > 1 # if there are more than 1 match in DB 
          all_valid = false
          error_msg = 'There are more than 1 record in database with the same first_name, last_name, and school_year,please manually update respective data through web interface'
          @upload_errors << "At row #{index + 2}: #{error_msg}"
        else 
          matched_student = query_result.first 
          @@valid_column_names.each do |cn|
            if s[cn] != nil && s[cn] != matched_student[cn]
              matched_student[cn] = s[cn]
              update_students << matched_student
            end 
          end 
        end 
      else # needs to insert 
        if s.invalid? 
          all_valid = false
          s.errors.full_messages.each do |e|
            @upload_errors << "At row #{index + 2}: #{e}"
          end
        else 
          insert_students << s
        end 
      end 
    end
    # insert data into db if all data valid
    if all_valid
      insert_students.each{|s| s.save}
      insert_count = insert_students.count
      update_students.each{|s| s.save}
      update_count = update_students.count
    end
    respond_to do |format|
      if all_valid
        notice_hash = {}
        notice_hash['data_imported'] = "Data imported!"
        if removed_columns.count > 0
          notice_hash['removed_columns'] = "Unidentified columns : " + removed_columns.to_s
        end 
        notice_hash['insert_count'] = "#{insert_count} student(s) inserted."
        notice_hash['update_count'] = "#{update_count} student(s) updated."
        
        format.html { redirect_to students_url, flash: notice_hash}
      else
        @students = Student.all
        format.html { render :index }
        format.json { render json: @upload_errors, status: :unprocessable_entity }
      end
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |product|
        csv << product.attributes.values_at(*column_names)
      end
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def student_params
    params.require(:student).permit(:first_name, :last_name, :school_year, :new_or_return, :student_class, :catholic, :parish, :race, :resides_with, :reference_from, :student_transfer, :preK_to_K, :father_name, :mother_name, :address, :city, :state, :zip, :email1, :email2, :note, :alumni, :reason, :K_First, :address2, :city2, :state2, :zip2, :phone1, :phone2)
  end

  def remove_extra_columns_for_csv(my_csv)
    removed_columns = []
    my_csv.headers.each do |h|
      if !(@@valid_column_names.include? h)
        my_csv.delete h
        removed_columns << h
      end
    end
    removed_columns
  end

  # remove rows if the row has 'columnX' as content
  def remove_column_rows(my_csv)
    my_csv.delete_if do |row|
      result = false
      # check only first 3 columns
      if row.headers.count >= 3
        result = true if row.field(0) =~ /\Acolumn.*\z/i && row.field(1) =~ /\Acolumn.*\z/i && row.field(2) =~ /\Acolumn.*\z/i
      end
      result
    end
  end
end
