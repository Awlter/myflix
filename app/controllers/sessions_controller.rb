class SessionsController < ApplicationController
  def new
    redirect_to home_path if logged_in?
  end

  def create
    session_params = params.permit(:email, :password)
    user = User.find_by(email: session_params[:email])

    if user && user.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to home_path, notice: 'Logged in successfully'
    else
      flash.now['error'] = 'Something went wrong.'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged Out!'
  end
end