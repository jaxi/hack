class BestRoutesWorker
  include Sidekiq::Worker
  sidekiq_options queue: "best_routes"

  def perform(wishlist_id)
    wishlist = Wishlist.find(wishlist_id)

    return if wishlist.state # Stop meaningless work

    BestRouteFinder.new(wishlist).work!
    TwilioMessage.new(wishlist).send!
  end
end