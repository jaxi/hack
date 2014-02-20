class AddTokenToWishlist < ActiveRecord::Migration
  def change
    add_column :wishlists, :token, :string
  end
end
