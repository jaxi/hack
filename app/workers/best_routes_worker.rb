class BestRoutesWorker
  include Sidekiq::Worker
  sidekiq_options queue: "best_routes"

  def perform(wishlist_id, budget)
    wishlist = Wishlist.find(wishlist_id)

    result = BestRouteFinder(wishlist, budget)
  end
end