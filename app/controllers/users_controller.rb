class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new show create)
  before_action :load_user, except: %i(new index create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def index
    @users = User.activated_user.paginate page: params[:page]
  end

  def show
    @microposts = @user.microposts.paginate page: params[:page]
    redirect_to root_url unless @user.activated
  end

  def destroy
    if @user.destroy
      flash[:success] = t "userdeleted"
    else
      flash[:warning] = t "usernotdeleted"
    end
    redirect_to users_url
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "checkemail1"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "updated"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return unless @user.nil?
    flash[:danger] = t "usernotfound"
    redirect_to root_url
  end
end
