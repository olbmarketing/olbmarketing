class MapController < ApplicationController

  def show
		@parishes = Parish.all
		@students = Student.where.not('latitude' => nil)
			.select("first_name, last_name, school_year, address, city, state, zip, latitude, longitude")
			.group_by {
				|student| student.school_year
			}
		render :map
  end
end
