class UsersController < ApplicationController

  def index
    @users = User.page(params[:page]).per(20)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Yay! User created!"
      redirect_to users_path
    else
      flash[:error] = "8( There was a problem while creating user"
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?
    if @user.update_attributes(params[:user])
      flash[:notice] = "Yay! User updated!"
      sign_in "user", @user, :bypass => true
      redirect_to users_path
    else
      flash[:error] = "8( There was a problem while updating user"
      render :edit
    end    
  end

  def disable
    @user = User.find(params[:id])
    @user.disable!
    redirect_to users_url
  end

  def enable
    @user = User.find(params[:id])
    @user.enable!
    redirect_to users_url
  end
end
