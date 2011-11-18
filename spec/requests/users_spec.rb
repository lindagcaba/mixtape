require 'spec_helper'

describe "Users" do
  describe "signup" do
     describe "failure" do 
       it "should not make a new user" do
         lambda do 
           visit new_user_path
           fill_in "Name",         :with => ""
           fill_in "Email",        :with => ""
           fill_in "Password",     :with => ""
           fill_in "Confirmation", :with => "" 
           click_button
           response.should render_template('users/new')
           response.should have_selector("div.alert-message")
         end.should_not change(User,:count)
       end
     end
     
     describe "success" do
       it "should create user" do 
         lambda do 
	   visit new_user_path
           fill_in "Name",   :with =>"linda"
           fill_in "Email",  :with =>"lindagcaba@gmail.com"
           fill_in "Password", :with =>"password"
           fill_in "Confirmation", :with => "password"

           click_button
           response.should render_template('users/show')
           response.should have_selector('div.alert-message', :content =>"Welcome to our App")
           
         end.should change(User,:count).by(1)
       end
     end
   end
 end
