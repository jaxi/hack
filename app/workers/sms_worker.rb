class SMSWorker
  include Sidekiq::Worker
  sidekiq_options queue: "sms"

  def perform(wishlist_id)
    wishlist = Wishlist.find(wishlist_id)
    TwilioMessage.new(wishlist).send!
  end
end