class CreateWishlists < ActiveRecord::Migration
  def change
    create_table :wishlists do |t|
      t.text :settings

      t.timestamps
    end
  end
end
