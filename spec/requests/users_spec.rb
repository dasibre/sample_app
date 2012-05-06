require 'spec_helper'

describe "Users" do

  describe "sign up" do
    it "should not create a new user" do
      lambda do
      	visit signup_path
     	 fill_in "Name", 			:with => ""
     	 fill_in "Email",			:with => ""
     	 fill_in "Password", 		:with => ""
     	 fill_in "Confirmation",	:with => ""
     	 click_button
     	 response.should render_template('users/new')
     	 response.should have_selector('div#error_explanation')
    	end.should_not change(User, :count)
	end

	it "should create a new user" do
		lambda do
      	visit signup_path
     	 fill_in "Name", 			:with => "Example User"
     	 fill_in "Email",			:with => "example@foo.com"
     	 fill_in "Password", 		:with => "foobar"
     	 fill_in "Confirmation",	:with => "foobar"
     	 click_button
     	 response.should have_selector('div.flash.success', :content => "welcome")
     	 response.should render_template('users/show')
     	end.should change(User, :count).by(1)
	end
  end

  describe "sign in" do

    describe "failure" do
      it "should not sign the user in" do
        visit signin_path
        fill_in "Email",    :with => ""
        fill_in "Password", :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "invalid")
        response.should render_template 'sessions/new'
      end
  end

  describe "success" do
      it "should sign the user in" do
        user = Factory(:user)
        visit signin_path
        fill_in "Email",    :with => user.email
        fill_in "Password", :with => user.password
        click_button
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
        response.should render_template 'users/show'
      end
  end
end
end
