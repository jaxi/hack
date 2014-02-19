class WishlistsController < ApplicationController

  before_action :can_visit?

  def index
    @wishlists = current_user.wishlists.all
  end

  def create
    @wishlist = if params[:cities]
      Wishlist.save_with_cities params[:cities]
    else
      nil
    end
    @wishlist.try{ |w|
      w.update_attributes user: current_user, name: (params[:name] || "Awesome wish!")
    }

    #@TODO add the backend job slave here

    respond_to do |format|
      format.js
    end
  end
end
