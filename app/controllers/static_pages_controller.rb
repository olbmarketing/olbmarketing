class StaticPagesController < ApplicationController
	before_filter :authorize
	
  def dashboard
  end

  def charts
  	@students = Student.all
  end
  
end
