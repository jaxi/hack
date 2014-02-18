class AirportsController < ApplicationController
  def autocomplete
    result = Airport.autocomplete(params[:query]).map do |airport|
      "#{airport.airport_name} Airport, #{airport.city_name}, #{airport.country_name}"
    end
    render json: {result: result}
  end
end
