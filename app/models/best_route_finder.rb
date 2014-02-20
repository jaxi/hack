class BestRouteFinder
  attr_reader :wishlist, :city_indexes

  attr_accessor :given_routes, :given_plans,
    :budget, :start_at, :cities

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
  end

  def work
    while cheapest_route; next; end
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
      next if response.length == 0

      # Tricky part. Kinda bad designed API
      if response.is_a? Array
        plan = response[0]
        price = plan["MinPrice"].to_f
      else
        plan = response
        price = response["MinPrice"].to_f
      end

      if budget - price >= 0 &&
        (best_price == nil ||
          price * city_indexes.index(city.id) > best_value)

        best_value = price * city_indexes.index(city.id)
        best_price = price
        chosen_city = city
        chosen_plan = plan
      end
    end

    if chosen_city && chosen_plan && best_price
      # ```budget -= best_price``` doesn't work. I don't know why.
      @budget = budget - best_price
      given_routes << chosen_city
      given_plans << chosen_plan
      cities.delete chosen_city

      # same issue, as described above
      @start_at += wishlist.stays[(city_indexes.index chosen_city.id)]
      return true
    else
      return false
    end
  end
end