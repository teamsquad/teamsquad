require 'digest/sha1'

class User < ActiveRecord::Base
  
  attr_protected :organisation_id
  
  before_create :crypt_password, :cleanse_email
  before_update :crypt_unless_empty_or_unchanged
  
  belongs_to :organisation
  
  validates_uniqueness_of   :email
  validates_length_of       :password, :within => 5..40, :on => :create
  validates_presence_of     :email, :name
  validates_confirmation_of :password, :if => Proc.new { |u| u.password && u.password.size > 0 }
  validates_format_of       :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  # echo "fivearsedmonkey" | openssl dgst -sha1
  @@salt = '9475f1fdc60cbb2493e1877563617ba3e62e643b'
  cattr_accessor :salt
  
  def self.login(email, password)
    user = find(
      :first,
      :conditions => ["email = ? AND password = ?", email.downcase, sha1(password)]
    )
    user or false
  end
  
  def hint(name)
    @@hints[name]
  end
  
protected

  # Apply SHA1 encryption to the supplied password. 
  # We will additionally surround the password with a salt 
  # for additional security. 
  def self.sha1(password)
    Digest::SHA1.hexdigest("#{salt}--#{password}--")
  end

  # Before saving the record to database we will crypt the password using SHA1. 
  # We never store the actual password in the DB.
  def crypt_password
    write_attribute "password", self.class.sha1(password)
  end

  # If the record is updated we will check if the password is empty or as was.
  # If so we assume that the user didn't want to change his/her
  # password and just reset/leave it as the old value.
  def crypt_unless_empty_or_unchanged
    user = self.class.find(self.id)
    if password.empty? or self.class.sha1(password) == self.class.sha1(user.password)    
      self.password = user.password
    else
      crypt_password
    end        
  end
  
  def cleanse_email
    self.email.downcase!
  end
  
  @@hints = {
    'name' => "Enter in your name as you wish to be known (e.g. Joe Bloggs).",
    'email' => "Enter in your email address. This must be a valid address.",
    'password' => "Enter a password you can remember so that you login with it.",
    'password_confirmation' => "Enter in your password again to confirm it is correct."
	}
  
end
