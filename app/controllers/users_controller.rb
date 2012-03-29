class UsersController < ApplicationController
  def new
  	@title = "sign up"
  end

  def show
  	@user = User.find(params[:id])
  end

end
