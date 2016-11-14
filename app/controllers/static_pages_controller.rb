class StaticPagesController < ApplicationController
	before_filter :authorize
	
  def dashboard
  end

  def charts
  end
  
  def generate_chart
  	@students = Student.where("school_year = ?", params[:q])
  end
end
