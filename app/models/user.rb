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
  def has_password?(password)
    encrypt(password) == encrypted_password 
  end  


  def self.authenticate(email,password)
     user = User.find_by_email(email)
     return nil if user.nil?|| !user.has_password?(password) 
     return user if user.has_password?(password)
  end
  
  def self.authenticate_with_salt(id, salt)
    user = User.find_by_id(id)
    return nil if user.nil?
    return user if user.salt == salt
  end
  

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
