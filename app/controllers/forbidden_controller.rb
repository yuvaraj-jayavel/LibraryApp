class ForbiddenController < ApplicationController
  def show
    redirect_to login_path
  end
end
