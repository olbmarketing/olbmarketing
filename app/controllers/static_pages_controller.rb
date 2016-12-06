class StaticPagesController < ApplicationController

  def dashboard
  end

  def charts
  	if params[:q] != nil
  		@students = Student.where("school_year = ?", params[:q])
  	else
  		@students = Student.all
  	end
  end
  
end
