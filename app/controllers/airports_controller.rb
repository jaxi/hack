class AirportsController < ApplicationController
  def autocomplete
    render json: {result: Airport.autocomplete(params[:query])}
  end
end
