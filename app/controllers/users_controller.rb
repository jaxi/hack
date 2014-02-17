class UsersController < ApplicationController
  before_action only: :update

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
end
