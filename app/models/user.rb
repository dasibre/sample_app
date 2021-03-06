# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#

class User < ActiveRecord::Base
	attr_accessor :password #creates a virtual password attribute
	attr_accessible :name, :email, :password, :password_confirmation #accessible makes attribute accessible outside of User model

	has_many :microposts, :dependent => :destroy
	has_many :relationships, :dependent => :destroy, :foreign_key => "follower_id"
	has_many :following, :through => :relationships, :source => :followed
	has_many :reverse_relationships, :dependent => :destroy, :foreign_key => "followed_id", :class_name => "Relationship"
	has_many :followers, :through => :reverse_relationships, :source => :follower
	

	email_regex = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i
	validates :name, :presence => true, 
			:length => { :maximum => 50 }
	validates :email, :presence => true, 
			  :format => { :with => email_regex}, 
			  :uniqueness => { :case_sensitive => false }
	validates :password, :presence => true,
			  :confirmation => true, :length => { :within => 6..20 }

	before_save :encrypt_password

	scope :admin, where(:admin => true)
	 
	 #compares encrypted_password attribute with submitted password
	 def has_password?(submitted_password)
	 	encrypted_password == encrypt(submitted_password)
	 end

	 def feed
	 	Micropost.from_users_followed_by(self)
	 end
	  
	  def following?(followed)
	  	relationships.find_by_followed_id(followed)
	  end

	  def follow!(followed)
	  	relationships.create!(:followed_id => followed.id)
	  end

	  def unfollow!(followed)
	  	relationships.find_by_followed_id(followed).destroy
	  end

	 private

	 def self.authenticate(email,password)
	 	user = User.find_by_email(email)
	 	(user && user.has_password?(password)) ? user : nil
	 	#return nil if user.nil?
	 	#return user if user.has_password?(password)
	
	 end

	 def self.authenticate_with_salt(id, cookie_salt)
	 	user = find_by_id(id)
	 	(user && user.salt == cookie_salt) ? user : nil
	 end
	 # sets salt and encrypted password attributes & calls encrypt method
	 #passes password attribute to encrypt method
	 def encrypt_password
	 	self.salt = make_salt if new_record?
	 	self.encrypted_password = encrypt(password)
	 end

	 #Call secure_hash, to encrypt user submitted password 
	 def encrypt(string)
	 	secure_hash("#{salt}--#{string}")
	 end

	 #create salt using Time.now and password attribute
	 def make_salt
	 	secure_hash("#{Time.new.utc}--#{password}")
	 end

	 def secure_hash(string)
	 	Digest::SHA2.hexdigest(string)
	 end
    
end
