class UsersController < ApplicationController
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
  end

  def edit 
  end
   
  
  def update
  end
  
  def destroy
  end
end
