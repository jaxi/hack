class BestRouteFinder
  attr_reader :wishlist, :city_indexes

  attr_accessor :given_routes, :given_plans,
    :budget, :start_at, :cities, :airline_map, :place_map

  def initialize(wishlist)
    @wishlist = wishlist
    @budget = wishlist.budget
    @city_indexes = wishlist.cities

    first, *@cities = wishlist.cities.map do |city|
      Airport.find_by(id: city)
    end

    @start_at = wishlist.start_at
    @stays = wishlist.stays
    @given_routes = [first]
    @given_plans = []

    @airline_map = {}
    @place_map = {}
  end

  def work
    while cheapest_route; next; end

    # FUCK OFF! Skyscanner!!
    given_plans.each do |plan|
      if plan["OutboundLeg"].is_a? Hash
        plan["carrier"] = airline_map[plan["OutboundLeg"]["CarrierIds"]["int"]]
        plan["OutboundLeg"].except! "CarrierIds"
        outbound = plan["OutboundLeg"].clone
        plan.except! "OutboundLeg"
        plan.merge! outbound
        plan["DepartureDate"] = plan["DepartureDate"].split("T").first
        plan["Origin"] = place_map[plan["OriginId"]]
        plan["Destination"] = place_map[plan["DestinationId"]]
        plan.except! "OriginId", "DestinationId"
      else
        plan["carrier"] = airline_map[plan["InboundLeg"]["CarrierIds"]["int"]]
        plan["InboundLeg"].except! "CarrierIds"
        inbound = plan["InboundLeg"].clone
        plan.merge! inbound
        plan["DepartureDate"] = plan["DepartureDate"].split("T").first
        plan["Origin"] = place_map[plan["OriginId"]]
        plan["Destination"] = place_map[plan["DestinationId"]]
        plan.except! "OriginId", "DestinationId"
        plan.except! "InboundLeg"
      end
    end

    puts @budget
    {
      given_routes: given_routes.map(&:id),
      given_plans: given_plans
    }
  end

  private
  def cheapest_route
    start_point = given_routes.last
    chosen_city = nil
    chosen_plan = nil
    best_price = nil
    best_value = -1

    cities.each do |city|
      begin
        response = Sky.cheapest_quotes(
          origin: start_point.city_id,
          destination: city.city_id,
          start_at: start_at.to_s,
          end_at: start_at.to_s
          )
      rescue
        next
      end

      # Tricky part. Kinda bad designed API
      next if response[:quotes].length == 0
      plan = nil
      response[:quotes].each do |q|
        # puts q["MinPrice"]
        if plan == nil || plan["MinPrice"] > q["MinPrice"]
          plan = q
        end
      end

      airline_map.merge! response[:carriers]
      place_map.merge! response[:places]

      price = plan["MinPrice"].to_f

      if @budget - price >= 0 &&
        (best_price == nil ||
          (city_indexes.length - city_indexes.index(city.id) + 1) / Math.sqrt(price) > best_value)

        best_value = (city_indexes.length - city_indexes.index(city.id) + 1) / Math.sqrt(price)
        best_price = price
        chosen_city = city
        chosen_plan = plan
      end
    end

    if chosen_city && chosen_plan && best_price
      # ```budget -= best_price``` doesn't work. I don't know why.
      @budget = @budget - best_price
      given_routes << chosen_city
      given_plans << chosen_plan
      cities.delete chosen_city

      # same issue, as described above
      @start_at += wishlist.stays[(city_indexes.index chosen_city.id)] + 1
      return true
    else
      return false
    end
  end
end