class SessionsController < ApplicationController
  before_action :find_user, only: :create

  def new; end

  def create
    if @user && @user.authenticate(params[:session][:password])
      check_active
    else
      flash.now[:danger] = t "invalidemail"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def find_user
    @user = User.find_by email: params[:session][:email].downcase
    return unless @user.nil?
    flash.now[:danger] = t "invalidemail"
  end

  def check_active
    if @user.activated?
      log_in @user
      params[:session][:remember_me] == Settings.checked ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      message = t "accountnotactivated"
      flash[:warning] = message
      redirect_to root_url
    end
  end
end
