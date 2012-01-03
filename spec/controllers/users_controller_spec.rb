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
     it "should sign in the user" do 
       put :create, :user => @attr
       controller.signed_in?.should be_true
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
      response.should have_selector('h1',:content=> @user.name )
    end
    it "should show a profile picture" do 
      get :show, :id => @user
      response.should have_selector('img',:class => "thumbnail")
    end
    describe "for current_user" do 
      before(:each) do 
       test_sign_in(@user)
      end
      it "should have an 'edit profile'" do 
        get :show, :id => @user
        response.should have_selector('a', :content =>"Edit Profile") 
      end
    end
  end
  describe "GET 'edit'" do
    before(:each) do 
      @user = Factory(:user)
      test_sign_in(@user)
    end
    it "should have http success" do 
      get :edit, :id => @user
      response.should be_success
    end
    it " should have the right title" do 
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit Profile" )
    end
  end
  describe "PUT 'update'" do
    before(:each) do  
      @user = Factory(:user)
      test_sign_in(@user) # sign the user in before can edit profile
    end 
    describe "failure" do
      before(:each) do
        @attr ={:name => "", :email => "", :password => "", :password_confirmation => ""}
      end
      it "should render the edit page" do 
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end
      it "should have the right title " do 
        put :update, :id => @user, :user => @attr
        response.should have_selector('title', :content =>"Edit Profile")
      end
    end

    describe "success" do
      before(:each) do 
       @attr ={:name =>"MrMan", :email => "mrman@gmail.com", :password => "newpassword", :password_confirmation => "newpassword"}
      end
      it "should redirect to profile page" do 
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end
      it "should update/change the user data" do 
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should  == @attr[:name]
        @user.email.should == @attr[:email]
      end
      it "should show flash messsage " do 
        put :update, :id => @user, :user => @attr
        flash[:success].should  =~ /profile updated/i
      end  
    end 
  end
  describe "restricting access to the edit/update actions" do
    describe "for non-signed in users" do  

      before(:each) do 
        @user = Factory(:user)
      end
      it "should deny access to 'edit' page "do 
        get :edit, :id => @user
        response.should redirect_to(signin_path())  
      end
      it "should deny access to 'update'" do
        put :update, :id => @user, :user =>{}
        response.should redirect_to(signin_path())
     end
   end
   describe "for signed-in users" do
      before(:each) do 
       @user = Factory(:user)
       wrong_user =Factory(:user,:email => "wronguser@email.com")
       test_sign_in(wrong_user)     
      end
      it "should deny access to 'edit' page for incorrect user" do
          get :edit, :id =>@user
          response.should redirect_to(root_path)
      end   
      it "should deny access  to 'update' for incorrect user" do
         put :update, :id => @user, :user =>{}
         response.should redirect_to(root_path)
      end
    end
  end
  describe "GET 'index'" do 
    before(:each) do 
     first_user = Factory.create(:user)
     second_user = Factory.create(:user, :name =>"Oscar", :email =>"second_user@gmail.com.com")
     @users = [first_user, second_user]
    end
    it"should return http success" do 
      get :index
      response.should be_success
    end
    it "should have the right title" do 
      get :index
      response.should have_selector('title',:content => "Members")
    end
    it "should correctly return all the users" do 
       get :index
       assigns(:users).should == @users
    end
    it "should display names of all users" do 
      get :index
      @users.each do |user|
         response.should have_selector('li',:content => user.name)
      end
    end
  end
  describe "DELETE 'destroy'" do 
    before(:each) do 
       @admin_user = Factory(:user, :admin => true)
       @non_admin_user1 = Factory(:user, :email => Factory.next(:email))
       @non_admin_user2 = Factory(:user, :email => Factory.next(:email))
    end
    describe "for non-signed in users" do 
      it "should not allow deletion " do 
        lambda do 
          delete :destroy, :id => @non_admin_user2
        end.should_not  change(User, :count).by(-1)
      end
      it "should redirect to signin page " do
        delete :destroy, :id => @non_admin_user2
        response.should redirect_to signin_path
      end
    end
    describe "for non-admin users" do
      before(:each) do 
        test_sign_in(@non_admin_user1)
      end
      it "should not allow deletion" do 
        lambda  do 
         delete :destroy, :id => @non_admin_user2
        end.should_not change(User,:count).by(-1)
      end
      it "should redirect to root with error message" do 
        delete :destroy, :id => @non_admin_user2
        response.should redirect_to(root_path)
        flash[:error].should =~ /Not Authorized/i
      end
    end
    describe "for admin users" do 
      before(:each) do 
        test_sign_in(@admin_user)
      end 
      it "should delete the user" do 
        lambda do 
          delete :destroy, :id => @non_admin_user2
        end.should change(User, :count).by(-1)
      end 
      it "should redirect to index page when done" do 
        delete :destroy, :id => @non_admin_user2
        response.should redirect_to(users_path)
        flash[:success].should =~ / Deleted /i
      end
    end
  end
end
