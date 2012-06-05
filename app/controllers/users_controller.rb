class UsersController < ApplicationController

  before_filter :authenticate, :except => [:show,:new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin,        :only => :destroy

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
  	@title = @user.name
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
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

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path, :flash => { :success => "User deleted"}
  end


  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin
    user = User.find(params[:id])
    redirect_to(root_path) unless (current_user.admin? && !current_user?(user))
  end
end
