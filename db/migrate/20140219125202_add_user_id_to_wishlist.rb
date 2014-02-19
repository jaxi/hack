class AddUserIdToWishlist < ActiveRecord::Migration
  def change
    add_reference :wishlists, :user, index: true
  end
end
