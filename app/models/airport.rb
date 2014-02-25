# == Schema Information
#
# Table name: airports
#
#  id           :integer          not null, primary key
#  airport_id   :string(255)
#  airport_name :string(255)
#  city_id      :string(255)
#  city_name    :string(255)
#  country_id   :string(255)
#  country_name :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  latitude     :float
#  longitude    :float
#

class Airport < ActiveRecord::Base
  searchkick autocomplete:
    [:airport_name, :city_name, :country_name]


  def self.autocomplete(query, limit: 10)
    self.search(query, autocomplete: true, limit: limit).map(&:prettify)
  end

  def prettify
    "#{airport_name}, #{city_name}, #{country_name}"
  end

  def self.find_by_full(query)
    airport_name = query.split(", ").first
    airport = self.where(airport_name: airport_name).first

    airport.fetch_again
    airport
  end

  def self.find_city_id(city)
    where(city_name: city).first.city_id
  end

  def self.find_city_id_by_query(query)
    city_name = query.split(", ").second
    self.find_city_id city_name
  end

  geocoded_by :prettify
  after_validation :geocode

  # SO SHIT
  def fetch_again
    puts "yes"
    unless self.latitude
      self.latitude, self.longitude = Geocoder.coordinates(self.prettify)
      self.save
    end
  end
end
