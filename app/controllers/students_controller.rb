class StudentsController < ApplicationController
  before_filter :authorize
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    @students = Student.all
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
    
    students_from_file = Student.get_students_from_file params[:file]
    
    all_valid = true 
    @upload_errors = []
    students_from_file.each_with_index do |s, index|
      all_valid = false if s.invalid?
      s.errors.full_messages.each do |e|
        @upload_errors << "At row #{index + 2}: #{e}"
      end 
    end 
    if all_valid 
      students_from_file.each{|s| s.save}
    end 
    respond_to do |format|
      if all_valid
        format.html { redirect_to students_url, notice: 'Data imported!' }
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
      params.require(:student).permit(:first_name, :last_name, :school_year, :new_or_return, :student_class, :catholic, :parish, :race, :resides_with, :reference_from, :student_transfer, :preK_to_K, :father_name, :mother_name, :address, :city, :state, :zip, :email1, :email2)
    end
end
