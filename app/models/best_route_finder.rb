class BestRouteFinder
  attr_reader :wishlist, :city_indexes, :origin_city

  attr_accessor :given_routes, :given_plans,
    :budget, :start_at, :cities, :airline_map, :place_map

  def initialize(wishlist)
    @wishlist = wishlist
    @budget = wishlist.budget
    fst, *rst = wishlist.cities
    @city_indexes = rst << fst

    @cities = wishlist.cities.map do |city|
      Airport.find_by(id: city)
    end

    @start_at = wishlist.start_at
    @stays = wishlist.stays
    @origin_city = @cities.first
    @given_routes = [@cities.first]
    @given_plans = []

    @airline_map = {}
    @place_map = {}
  end

  def work!
    while cheapest_route; next; end

    # FUCK OFF! Skyscanner!!
    given_plans.each do |plan|
      plan["Carrier"] = airline_map[plan["OutboundLeg"]["CarrierIds"]["int"]]
      plan["OutboundLeg"].except! "CarrierIds"
      outbound = plan["OutboundLeg"].clone
      plan.merge! outbound
      plan["DepartureDate"] = plan["DepartureDate"].split("T").first
      plan["Origin"] = place_map[plan["OriginId"]]
      plan["Destination"] = place_map[plan["DestinationId"]]
      plan.except! "OriginId", "DestinationId"
      plan.except! "OutboundLeg"
    end

    wishlist.update_attributes(
      given_routes: given_routes.map(&:id),
      given_plans: given_plans
      )
  end

  private
  def cheapest_route
    start_point = given_routes.last
    chosen_city = nil
    chosen_plan = nil
    best_price = nil
    origin_price = nil
    origin_plan = nil

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
        if plan == nil ||
          (plan["MinPrice"] > q["MinPrice"] && q["OutboundLeg"].is_a?(Hash))
          plan = q
        end
      end

      if plan == nil?
        @start_at += 1
        return true
      end

      airline_map.merge! response[:carriers]
      place_map.merge! response[:places]

      price = plan["MinPrice"].to_f

      if city == origin_city
        origin_price = price
        origin_plan = plan
      end

      if @budget - price >= 10 &&
        (best_price == nil ||
          ((city_indexes.length - city_indexes.index(city.id) + 1) ** 0.5) / (price ** 1.5) > best_value)

        best_value = ((city_indexes.length - city_indexes.index(city.id) + 1) ** 0.5) / (price ** 1.5)
        best_price = price
        chosen_city = city
        chosen_plan = plan
      end
    end

    if origin_price.nil? && origin_city != start_point
      @start_at += 1
      return true
    end

    if chosen_city && chosen_plan && best_price

      if best_price != origin_price && origin_price && @budget - best_price - origin_price <= 10
        @budget = @budget - origin_price
        given_routes << origin_city
        given_plans << origin_plan
        return false
      end
      # ```budget -= best_price``` doesn't work. I don't know why.
      @budget = @budget - best_price
      given_routes << chosen_city
      given_plans << chosen_plan
      cities.delete chosen_city

      # same issue, as described above
      # @start_at += wishlist.stays[(city_indexes.index chosen_city.id)] + 1
      @start_at += rand(1..3)

      return false if chosen_city == given_routes.first
      return true
    else
      return false
    end
  end
end