class AddBudgetAndResultToWishlist < ActiveRecord::Migration
  def change
    add_column :wishlists, :budget, :decimal, :precision => 8, :scale => 2
    add_column :wishlists, :result, :text
  end
end
