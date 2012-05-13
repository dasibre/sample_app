class UsersController < ApplicationController

  before_filter :authenticate, :only => [:edit, :update]

  def index
    @user = User.find :all
  end
  
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

  def edit
    @user = User.find(params[:id])
    @title = "Edit account"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user
      flash[:success] = "profile updated"
    else
    @title = "Edit account"
    render 'edit'
  end

  end


  private

  def authenticate
      #flash[:notice] = "Sign in to access page"
      deny_access unless signed_in?
  end

end
