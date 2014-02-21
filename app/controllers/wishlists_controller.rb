class WishlistsController < ApplicationController

  before_action :can_visit?, except: [:ical]

  def index
    @wishlists = current_user.wishlists.all
  end

  def create
    return render json: {success: false} unless params[:cities]

    @wishlist = Wishlist.save_with_cities params[:cities]
    @wishlist.update_attributes(
      user: current_user,
      name: params[:name],
      start_at: params[:start_at],
      budget: params[:budget]
      )

    # Here you are
    BestRoutesWorker.perform_async @wishlist.id if @wishlist

    respond_to do |format|
      format.js
    end
  end

  def update_sms_state
    @wishlist = Wishlist.find_by_id params[:id]
    @wishlist.update_attributes sms_state: true

    respond_to do |format|
      format.js
    end
  end

  def sms
    SMSWorker.perform_async params[:id]
    @wishlist = Wishlist.find_by id: params[:id]
    respond_to do |format|
      format.js
    end
  end

  def polling_charge
    @wishlists = Wishlist.newly_completed *params[:uncompleted].map(&:to_i)

    result = @wishlists.map do |wishlist|
      {
        id: wishlist.id,
        html: render_to_string(partial: "wishlists/completed_wishlist", layout: false,
          locals: {wishlist: wishlist})
      }
    end

    render json: result
  end

  def ical
    wishlist = Wishlist.find_by(token: params[:token])
    return render json: "No such calendar" unless wishlist
    ical = Ical.new wishlist
    render text: ical.generate!, content_type: 'text/calendar'
  end
end
