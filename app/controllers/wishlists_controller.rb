class WishlistsController < ApplicationController

  before_action :can_visit?

  def index
    @wishlists = current_user.wishlists.all
  end

  def create
    return render json: {success: false} unless params[:cities]

    @wishlist = Wishlist.save_with_cities params[:cities]
    @wishlist.update_attributes(
      user: current_user,
      name: (params[:name] || "Awesome wish!"),
      start_at: params[:start_at]
      )

    # Here you are
    BestRoutesWorker.perform_async @wishlist.id if @wishlist

    respond_to do |format|
      format.js
    end
  end
end
