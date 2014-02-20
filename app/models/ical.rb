class Ical
  attr_reader :wishlist
  attr_accessor :icalendar

  def initialize(wishlist)
    @wishlist = wishlist
    @icalendar = Icalendar::Calendar.new
  end

  def generate
    icalendar.custom_property 'x-wr-calname', "#{wishlist.name}"
    wishlist.given_plans.each do |plan|
      icalendar.event do
        dtstart Date.parse(plan["DepartureDate"])
        dtend Date.parse(plan["DepartureDate"]) + 1.day
        summary "From #{plan["Origin"]} to #{plan["Destination"]}"
        description "From #{plan["Origin"]} to #{plan["Destination"]} via #{plan["Carrier"]} at #{plan["DepartureDate"]}"
        klass "PRIVATE"
      end
    end
  end

  def generate!
    generate
    icalendar.to_ical
  end
end