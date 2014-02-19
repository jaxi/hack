class AddStartAtAndEndAtToWishlist < ActiveRecord::Migration
  def change
    add_column :wishlists, :start_at, :date
    add_column :wishlists, :end_at, :date
  end
end
