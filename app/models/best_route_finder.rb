class BestRouteFinder
  attr_reader :wishlist
  attr_accessor :given_routes, :given_plans, :budget, :start_at, :cities

  def initialize(wishlist, budget)
    @wishlist = wishlist
    @budget = budget

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
      given_routes: given_routes,
      given_plans: given_plans
    }
  end

  private
  def cheapest_route
    start_point = given_routes.last
    chosen_city = nil
    chosen_plan = nil
    min_price = 1000000

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
      plan = response[0]
      price = plan["MinPrice"].to_i
      if budget - price >= 0 && price < min_price
        min_price = price
        chosen_city = city
        chosen_plan = plan
      end
    end

    if chosen_city && chosen_plan && min_price
      # ```budget -= min_price``` doesn't work. I don't know why.
      @budget = budget - min_price
      given_routes << chosen_city
      given_plans << chosen_plan
      cities.delete chosen_city
      # same with this, as described above
      @start_at += wishlist.stays[(wishlist.cities.index chosen_city.id)]
      return true
    else
      return false
    end
  end
end