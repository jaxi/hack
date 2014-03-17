class AddIndexToAirport < ActiveRecord::Migration
  def change
    add_index :airports, :airport_name
    add_index :airports, :city_name
    add_index :airports, :country_name
  end
end
