class AirportsController < ApplicationController
  def autocomplete
    render json: Airport.autocomplete(params[:query])
  end

  def geocode
    render json: Airport.find_by_full(params[:airport])
  end
end
