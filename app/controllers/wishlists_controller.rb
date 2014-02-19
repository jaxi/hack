class WishlistsController < ApplicationController
  def create
    @wishlist = Wishlist.save_with_cities params[:cities]

    render json: {success: true, wishlist: @wishlist}
  end
end
