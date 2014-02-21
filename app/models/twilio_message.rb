class TwilioMessage

  attr_reader :wishlist, :phone_number

  def initialize(wishlist)
    @wishlist = wishlist
    @phone_number = wishlist.try { |w| w.user.mobile }
    raise "No Phone Number " unless @phone_number
  end

  def send!
    return unless wishlist.sms_state
    TWILLIO_CLIENT.account.messages.create(
      from: TWILIO_PHONE,
      to: phone_number,
      body: body
      )
  end

  private
  def body
    ical_url = "You can subscirbe it to your calendar via #{ENV['SITE']}ical/#{wishlist.token}"
    # title = wishlist.name
    # messages = wishlist.given_plans.map{ |plan|
    #   "From #{plan["Origin"]} to #{plan["Destination"]} via #{plan["Carrier"]} at #{plan["DepartureDate"]}, which takes you #{plan["MinPrice"]} £."
    # }.join("\n")

    # "#{title}\n#{messages}\n#{ical_url}"
    ical_url
  end
end