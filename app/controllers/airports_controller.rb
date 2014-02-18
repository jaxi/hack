class AirportsController < ApplicationController
  def autocomplete
    render json: Airport.autocomplete(params[:query])
  end
end
