class PasswordResetsController < ApplicationController
  before_action :load_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update) # Case (1)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "emailsent"
      redirect_to root_url
    else
      flash.now[:danger] = "emailnotfound"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?                  # Case (3)
      @user.errors.add(:password, t("notempty"))
      render :edit
    elsif @user.update_attributes user_params           # Case (4)
      log_in @user
      update_contain
    else
      render :edit                                      # Case (2)
    end
  end

  private

  def update_contain
    @user.update_attributes reset_digest: nil
    flash[:success] = t "successreset"
    redirect_to @user
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    return unless @user.nil?
    flash[:danger] = t "usernotfound"
    redirect_to root_url
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "passexpired"
    redirect_to new_password_reset_url
  end
end
