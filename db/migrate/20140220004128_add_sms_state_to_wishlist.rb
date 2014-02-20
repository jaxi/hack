class AddSmsStateToWishlist < ActiveRecord::Migration
  def change
    add_column :wishlists, :sms_state, :boolean
  end
end
