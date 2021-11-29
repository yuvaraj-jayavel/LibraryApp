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
      flash.now[:form_error] = I18n.t('invalid_username_or_password')
      render 'new'
    end
  end

  def destroy
    log_out
    flash[:snack_success] = I18n.t('you_have_successfully_logged_out')
    redirect_to root_path
  end

  def login_params
    params
      .require(:session)
      .permit(:username, :password)
  end
end
