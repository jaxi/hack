class SessionController < ApplicationController

  before_action only: :update

  def edit
    @user = User.find_by_id params[:id]
  end

  def update
    @user = User.find_by_id params[:id]
    @user.update_attributes user_params
    redirect_to root_path
  end

  def create
    @user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = @user.id
    if @user.mobile.present?
      redirect_to root_url
    else
      redirect_to edit_user_path(@user)
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

  private
  def user_params
    params.require(:user).permit(:provider, :email, :uid, :state, :mobile)
  end

end
