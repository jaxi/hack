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

  default_scope order('updated_at DESC')

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

    list.token = SecureRandom.uuid.delete('-') unless list.token
    list.name = "An Unamed Wish List" if list.name == "" || list.name == nil

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
    list.budget = 1000 if list.budget.nil? || list.budget == ""

    list.given_routes ||= []
    list.given_plans ||= []
    list.state = true if list.given_routes.length > 0
  end

  def self.newly_completed(*indexes)
    where("id IN (?) and state = ?", indexes, true).to_a
  end
end
