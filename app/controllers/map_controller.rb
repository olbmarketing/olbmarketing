class MapController < ApplicationController
	before_filter :authorize

  def show
		render :map
  end
end
