class UsersController < ApplicationController
  
  def show
  	@user = User.find(params[:id])
  	@title = @user.name
  end

  def new
  	@title = "sign up"
  	@user = User.new
  end

  def create
  	#raise params[:user].inspect
  	@user = User.new(params[:user])
  	if @user.save
  		redirect_to(@user)
      flash[:success] = "welcome to sample app"
      sign_in(@user)
  	else
  	@title = "sign up"
  	render 'new'
  	end
  	#redirect_to user_path(@user)

  end

end
