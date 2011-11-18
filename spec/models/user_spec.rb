require 'spec_helper'

describe User do
  before(:each) do 
   @attr ={:name => "ValidUser",
           :email =>"validuser@gmail.com",
           :password => "validpassword",
           :password_confirmation =>"validpassword" }
  end 

 
  it "should create new  User given valid attributes" do 
     User.create!(@attr) 
  end 
  
  it "should require a name" do 
     no_name_user = User.new(@attr.merge(:name => ""))
     no_name_user.should_not be_valid
  end 

  it "should reject very long name" do 
     long_name_user = User.create(@attr.merge(:name =>"a"*51))
     long_name_user.should_not be_valid
  end
 
  it "should require an email" do 
     no_email_user = User.create(@attr.merge(:email =>""))
     no_email_user.should_not be_valid
  end
  it "should reject invaid emails" do 
    addresses = %w[linda@gmail linda.gmail.com linda_at_gmail.com linda@gmail,com ]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email=> address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should accept valid emails" do 
    addresses = %w[linda@gmail.com linda.gcaba@gmail.com LINDA@sun.ac.za]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end 
  it "should reject duplicate emails" do
    User.create!(@attr)
    duplicate_user = User.new(@attr)
    duplicate_user.should_not be_valid
  end 
 
  it "should reject duplicate email up to case" do 
    User.create!(@attr)
    upcase_email = @attr[:email].upcase
    duplicate_user = User.new(@attr.merge(:email => upcase_email))
    duplicate_user.should_not be_valid
  end

  describe "password validations" do 
    it "should require a password" do 
      no_password_user = User.new(@attr.merge(:password =>"", :password_confirmation =>""))
      no_password_user.should_not be_valid
    end
    it "should reject short passwords " do 
       short = "a"*5
       short_password_user = User.new(@attr.merge(:password =>short, :password =>short))
       short_password_user.should_not be_valid
    end
   
    it "should reject very long passwords " do 
      long = "a"*51
      long_password_user = User.new(@attr.merge(:password =>long, :password_confirmation =>long))
      long_password_user.should_not be_valid
    end   
    it "should have a matching password_confirmation " do 
      User.new(@attr.merge(:password_confirmation =>"invalid")).should_not be_valid
    end
    it "should encrypt password " do 
      @user = User.create!(@attr)
      @user.should respond_to(:encrypted_password)

    end
    
    it "should have non-blank encrypted_password" do 
       @user = User.create!(@attr)
       @user.encrypted_password.should_not be_blank
    end
     
   
  end
 
 
end
