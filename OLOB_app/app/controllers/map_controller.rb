class MapController < ApplicationController
	before_filter :authorize

  def show
		@parishes = Parish.all
		@students = Student.where.not('address' => nil)
			.select("first_name, last_name, school_year, address, city, state, zip")
			.group_by {
				|student| student.school_year
			}
		render :map
  end
end
