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
#

require 'spec_helper'

describe User do
  #pending "add some examples to (or delete) #{__FILE__}"
  before(:each) do
  	@attr = {:name => "Example User", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar" }
  end
  it "should create a new instance given a valid attribute" do
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

  #testing for password for user object
  describe "passwords" do
    before(:each) do
      @user = User.new(@attr)
    end
    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end

    it "should reject short passwords" do
      short_password = "a" * 5
      short_password_user = User.new(@attr.merge(:password => short_password, :password_confirmation => short_password))
      short_password_user.should_not be_valid
    end

    it "should reject long passwords" do
      long_password = "a" * 21
      long_password_user = User.new(@attr.merge(:password => long_password, :password_confirmation => long_password))
      long_password_user.should_not be_valid
    end
  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted_password" do
      @user.encrypted_password.should_not be_blank
    end

    it "should have a salt" do
      @user.should respond_to(:salt)
    end

    describe "has_password? method" do

      it "should exist" do
        @user.should respond_to(:has_password?)
      end

      it "should be true if passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if passwords dont match" do
        @user.has_password?("invalid").should be_false
      end
    end

    describe "authenticate method" do

      it "should return nill on email/password mismatch" do
        User.authenticate(@attr[:email], "wrongpass").should be_nil
      end

      it "should return for non existent email address" do
        User.authenticate("boo@foo.com", @attr[:password]).should be_nil
      end

      it "should return the user with correct login info" do
        User.authenticate(@attr[:email], @attr[:password]).should == @user
      end
    end
  end

end