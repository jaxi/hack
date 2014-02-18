class AirportsController < ApplicationController
  def autocomplete
    render json: Airport.search(params[:query], autocomplete: true, limit: 5)
  end
end
