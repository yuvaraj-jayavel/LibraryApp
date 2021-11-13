class SessionsController < ApplicationController
  def new
    redirect_to root_path if logged_in?
  end

  def create
    staff = Staff.find_by(username: login_params[:username])
    if staff&.authenticate(login_params[:password])
      log_in staff
      remember staff
      redirect_to root_path
    else
      flash.now[:form_error] = 'Invalid username or password!'
      render 'new'
    end
  end

  def destroy
    log_out
    flash[:snack_success] = 'You have successfully logged out'
    redirect_to root_path
  end

  def login_params
    params
      .require(:session)
      .permit(:username, :password)
  end
end
