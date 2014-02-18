class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :airport_id
      t.string :airport_name
      t.string :city_id
      t.string :city_name
      t.string :country_id
      t.string :country_name

      t.timestamps
    end
  end
end
