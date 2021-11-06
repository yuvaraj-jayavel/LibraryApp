# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pundit

  def hello
    render html: 'Hello world!'
  end

  def pundit_user
    current_staff
  end
end
