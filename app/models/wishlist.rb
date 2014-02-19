# == Schema Information
#
# Table name: wishlists
#
#  id         :integer          not null, primary key
#  settings   :text
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  start_at   :date
#  end_at     :date
#

class Wishlist < ActiveRecord::Base

  store :settings, accessors: [:cities, :stays]

  belongs_to :user

  def city_names
    cities.map do |city|
      Airport.find_by(id: city).prettify
    end
  end

  def self.save_with_cities(cities)
    city_ids = cities.map do |city|
      Airport.find_by_full(city).id
    end

    self.create cities: city_ids
  end

  before_save do |list|
    # save the date
    list.start_at ||= Date.today
    list.end_at ||= Date.today

    # city list init, so dirty
    unless list.cities
      list.cities = []
      list.stays = []
    end

    if list.cities.length == list.stays.try(:length)
      list.stays.each do |stay|
        stay = 0 unless stay
      end
    else
      list.stays = [0] * list.cities.length
    end
  end
end
