class WishlistsController < ApplicationController
  def create
    @wishlist = if params[:cities]
      Wishlist.save_with_cities params[:cities]
    else
      nil
    end
    render json: {success: true, wishlist: @wishlist}
  end
end
