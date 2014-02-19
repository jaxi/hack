class AddStateAndNameToWishlist < ActiveRecord::Migration
  def change
    add_column :wishlists, :state, :boolean
    add_column :wishlists, :name, :string
  end
end
