require 'spec_helper'

describe RelationshipsController do
	it "should require signin for create" do
		post :create
		response.should redirect_to(signin_path)
	end

	it "should require signin for delete" do
		post :destroy, :id => 1
		response.should redirect_to(signin_path)
	end

	describe "Post 'create'" do

		before(:each) do
			@user = test_sign_in(Factory(:user))
			@followed = Factory(:user, :email => Factory.next(:email))
		end

		it "should create a relationship" do
			lambda do
				post :create, :relationship => { :followed_id => @followed}
				response.should redirect_to(user_path(@followed))
			end.should change(Relationship, :count).by(1)
		end

		it "should create relationship with Ajax" do
			lambda do 
				xhr :post, :create, :relationship => { :followed_id => @followed}
				response.should be_success
			end.should change(Relationship, :count).by(1)
				
		end
	end

	describe "Delete 'destroy'" do

		before(:each) do
			@user = test_sign_in(Factory(:user))
			@followed = Factory(:user, :email => Factory.next(:email))
			@user.follow!(@followed)
			@relationship = @user.relationships.find_by_followed_id(@followed)
		end
		
		it "should delete a relationship" do
			lambda do
			delete :destroy, :id => @relationship
			response.should redirect_to(user_path(@followed))
			end.should change(Relationship, :count).by(-1)
		end

		it "should destroy relationship with Ajax" do
			lambda do 
				xhr :delete, :destroy, :id => @relationship
				response.should be_success
			end.should change(Relationship, :count).by(-1)		
		end

	end
end