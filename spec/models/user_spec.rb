# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
  #pending "add some examples to (or delete) #{__FILE__}"
  before(:each) do
  	@attr = {:name => "Example User", :email => "user@example.com" }
  end
  it "should create a new instrance given a valide attribute" do
  	User.create!(@attr)
  end

  it "should require a name" do
  	user_no_name = User.new(@attr.merge!(:name => ' '))
  	user_no_name.should_not be_valid
  end

  it "should require an email address" do
  	user_no_email = User.new(@attr.merge!(:email => ' '))
  	user_no_email.should_not be_valid
  end

  it "should reject long names" do
  	long_name = "a" * 51
  	long_name_user = User.new(@attr.merge!(:name => long_name))
  	long_name_user.should_not be_valid
  end

  it "should accept valid email address" do
  	addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
  	addresses.each do  |email_add| 
  		valid_email = User.new(@attr.merge!(:email => email_add))
  		valid_email.should be_valid
 	 end
  end

   it "should reject invalid email address" do
  	addresses = %w[user@ foo,com THE_USER-foo.bar.org first.lastatfoo.jp]
  	addresses.each do  |email_add| 
  		invalid_valid_email = User.new(@attr.merge!(:email => email_add))
  		invalid_valid_email.should_not be_valid
 	 end
  end

  it "should reject duplicate emails" do
  	User.create!(@attr)
  	user_with_duplicate_email = User.new(@attr)
  	user_with_duplicate_email.should_not be_valid
  end

  #tests email case so no duplicates are created
   it "should reject emails up to case" do
   	upcased_email = "USER@EXAMPLE.COM"
  	User.create!(@attr.merge(:email => upcased_email))
  	user_with_duplicate_email = User.new(@attr)
  	user_with_duplicate_email.should_not be_valid
  end
end
