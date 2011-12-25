class UsersController < ApplicationController

  before_filter :authenticate, :only =>[:edit, :update]
  before_filter :correct_user, :only =>[:edit,:update]
  def new
    @title = "Sign up"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
   
    if @user.save
       sign_in(@user)
       flash[:success] = "Welcome to our App" 
       redirect_to @user
    else
       @title = "Sign up"
       @user.password.clear
       @user.password_confirmation.clear
       render 'new'
    end
  end

  def show
    @user  = User.find(params[:id])
    @title = @user.name
  end
  
  def index
    @title = "Members"
    @users = User.all  
  end

  def edit
    @user = User.find(params[:id])
    @title = "Edit Profile" 
  end
   
  
  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(params[:user])
       flash[:success] = "Profile updated"
       redirect_to(@user)
    else
      @title ="Edit Profile"
      render 'edit'
    end
  end
  
  def destroy
  end
  private 
    def authenticate
      deny_access unless signed_in?
    end
    def correct_user 
      @user = User.find(params[:id])
      redirect_to root_path unless @user == current_user
    end
    
end
