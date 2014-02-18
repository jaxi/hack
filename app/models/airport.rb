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
#

class Airport < ActiveRecord::Base
  searchkick autocomplete:
    [:airport_id, :airport_name, :city_id, :city_name, :country_id, :country_name]


  def self.autocomplete(query, limit: 10)
    self.search(query, autocomplete: true, limit: limit).map(&:prettify)
  end

  def prettify
    "#{airport_name} Airport, #{city_name}, #{country_name}"
  end

  geocoded_by :prettify
  after_validation :geocode
end
