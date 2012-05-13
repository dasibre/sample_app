class SessionsController < ApplicationController
  def new
  	@title = 'sign in'
  end

  def create
    user = User.authenticate(params[:session][:email],
                           params[:session][:password])
  	#user = User.authenticate(params[:email], params[:password])
    if user.nil?
      flash.now[:error] = "invalid email/password combo"
      @title = "sign in"
      render 'new'
    #user = User.find_by_email(params[:email])

  	#if user && user.has_password?(params[:password])
  		#session[:user_id] = user.id
  	#	redirect_to user, :notice => "Logged In"
  	else
  		sign_in user
      redirect_back_or user
      #flash.now[:error] = "Invalid email or password"
  		#@title = 'sign in'
  		#render 'new'
  	end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
