class StaticPagesController < ApplicationController
	before_filter :authorize
	
  def dashboard
  end

  def charts
    @studentList = Student.uniq.pluck(:school_year)
  	if params[:q] != nil
  		@students = Student.where("school_year = ?", params[:q])
  	else
  		@students = Student.all 
  	end
  end
  
end
