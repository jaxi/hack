class Wishlist < ActiveRecord::Base

  store :settings, accessors: [:cities, :stays]

  def city_names
    cities.map do |city|
      Airport.find_by(id: city).prettify
    end
  end

  before_save do |list|
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
