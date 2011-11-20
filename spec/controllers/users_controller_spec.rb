require 'spec_helper'

describe UsersController do
  render_views
  describe "GET 'new'" do
    it "returns http success" do
      get :new
      response.should be_success
    end
    it "should have the right title" do 
       get :new
       response.should have_selector('title',:content =>"Sign up")
    end 
  end
  describe "POST 'create'" do
    describe "failure" do 
      before(:each) do 
        @attr ={:name =>"",:email =>"",:password =>"er",:password_confirmation =>"er"}
      end
      it"should not create user" do 
        lambda do 
          post :create, :user => @attr
        end.should_not change(User, :count)
      end 
      it"should have the right title after signup failure" do 
        post :create, :user => @attr
        response.should have_selector('title', :content => "Sign up")
      end
    
      it "should render 'new' " do 
        post :create,:user => @attr
        response.should render_template('new') 
      end
     it "should clear the password field" do
       post :create, :user => @attr
       response.should have_selector("input#user_password",:value =>"")
     end
     it "should clear the password confirmation field" do 
        post :create,:user => @attr
        response.should have_selector("input#user_password_confirmation", :value =>"")
     end
    end 
    describe "success" do 
      before(:each) do 
        @attr = {:name => "linda",:email =>"lindagcaba@gmail.com",:password =>"password",:password_confirmation => "password"}
      end
     
      it"should create user" do 
        lambda do
          put :create, :user => @attr
        end.should change(User,:count).by(1)
      end
      it "should render 'show' page" do 
        put :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      it "should have a welcome message on show page" do 
        put :create, :user => @attr
        flash[:success].should =~ /welcome to our app/i
      end
    end
  end
  describe "GET 'show' "do 
    before(:each) do 
      @user = Factory(:user)
    end 
    it"should be successful" do 
      get :show,:id => @user
      response.should be_success
    end
    it "should fetch the correct user" do 
      get :show,:id => @user
      assigns(:user).should == @user
    end
    it"should have the right title" do 
      get :show, :id => @user
      response.should have_selector('title', :content => @user.name )
    end
    it "should have the name of the user" do 
      get :show, :id => @user
      response.should have_selector('h1',:content=>@user.name )
    end
    it "should show a profile picture" do 
      get :show, :id => @user
      response.should have_selector('img',:class =>"thumbnail")
    end
  end

end
