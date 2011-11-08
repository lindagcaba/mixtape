class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  
  
  
 
  email_regex =/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
  validates_presence_of   :name
  validates_length_of     :name,:maximum => 50
  validates_presence_of   :email
  validates_format_of     :email, :with => email_regex
  validates_uniqueness_of :email, :case_sensitive => false

end
