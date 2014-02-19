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
    [:airport_id, :airport_name, :city_id, :city_name, :country_id, :country_name]


  def self.autocomplete(query, limit: 10)
    self.search(query, autocomplete: true, limit: limit).map(&:prettify)
  end

  def prettify
    "#{airport_name}, #{city_name}, #{country_name}"
  end

  def self.find_by_full(query)
    airport = query.split(", ").first
    self.where(airport_name: airport).first
  end

  geocoded_by :prettify
  after_validation :geocode
end
