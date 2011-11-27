require 'spec_helper'

describe SessionsController do
  render_views
  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
    it "should have the right title" do 
      get :new  
      response.should have_selector("title", :content =>"Sign in")
    end 
  end


  describe "POST 'create'" do
    before(:each) do 
      @attr = {:email =>"lindagcaba@gmail.com",:password =>"invalidto"}
    end
  
    describe "signin failure" do 
      it"should render the signup page " do  
         post :create, :session => @attr 
         response.should render_template('new')
      end
      it "should display an error message" do 
         post :create, :session => @attr
         flash.now[:error].should =~ /invalid/i
      end
      
      it "should have the right title on failed signin" do
        post :create, :session => @attr
        response.should have_selector("title", :content =>"Sign in")
      end
    end  
    
    describe "signin success" do 
      before(:each) do 
        @user = Factory(:user)
        @attr ={:email => @user.email, :password => @user.password}
      end
      it "should sign in user" do 
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.signed_in?.should be_true  #controller.should be_signed_in
      end
      it "should redirect to profile/show page" do 
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end
    end
  end

  describe " DELETE 'destroy'" do
    it "should sign user out" do 
      test_sign_in(Factory(:user))
      delete :destroy
      controller.signed_in?.should be_false
      response.should redirect_to(root_path) 
    end
  end

end
