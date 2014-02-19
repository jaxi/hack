class BestRoutesWorker
  include Sidekiq::Worker
  sidekiq_options queue: "best_routes"

  def perform(wishlist_id)
    wishlist = Wishlist.find(wishlist_id)

    return if wishlist.state # Stop meaningless work

    result = BestRouteFinder.new(wishlist).work
    wishlist.update_attributes result
  end
end