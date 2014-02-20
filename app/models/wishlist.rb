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
#  state      :boolean
#  name       :string(255)
#  budget     :decimal(8, 2)
#  result     :text
#  sms_state  :boolean
#

class Wishlist < ActiveRecord::Base

  store :settings, accessors: [:cities, :stays]
  store :result, accessors: [:given_routes, :given_plans]

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

  def prettify_state
    state ? "Got it!" : "Wait, wait! We are still working hard on this :)"
  end

  before_save do |list|
    list.name ||= "An Unamed Wish List"

    # default is false
    list.state = false
    list.sms_state ||= false

    # save the date
    list.start_at ||= Date.today + 5.day
    list.end_at ||= Date.today + 5.day

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

    # init the budget, given_plan and given_routes. Well, I know it's too nasty though.
    list.budget ||= 1000
    list.given_routes ||= []
    list.given_plans ||= []
    list.state = true if list.given_routes.length > 0
  end
end
