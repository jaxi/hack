class WishlistsController < ApplicationController

  before_action :can_visit?

  def index
    @wishlists = Wishlist.all
  end

  def create
    @wishlist = if params[:cities]
      Wishlist.save_with_cities params[:cities]
    else
      nil
    end
    render json: {success: true, wishlist: @wishlist}
  end
end
