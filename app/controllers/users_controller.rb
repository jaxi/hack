class UsersController < ApplicationController
  before_action only: :update
  before_action :has_permission?

  def edit
    @user = User.find_by_id params[:id]
  end

  def update
    @user = User.find_by_id params[:id]
    @user.update_attributes user_params
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:provider, :email, :uid, :state, :mobile)
  end

  def has_permission?
    redirect_to root_path unless current_user && params[:id] == current_user.id
  end
end
