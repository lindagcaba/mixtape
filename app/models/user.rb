require 'digest'
class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  attr_accessor   :password 
  
  
 
  email_regex =/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
  validates_presence_of   :name
  validates_length_of     :name,:maximum => 50
  validates_presence_of   :email
  validates_format_of     :email, :with => email_regex
  validates_uniqueness_of :email, :case_sensitive => false
  validates_presence_of    :password
  validates_length_of     :password, :within => 6..50
  validates_confirmation_of :password

  before_save :encrypt_password
 
  private
   
    def encrypt_password
      self.salt = make_salt if new_record? #make salt if the record is new
      self.encrypted_password = encrypt(self.password)
    end
  
    def  encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
