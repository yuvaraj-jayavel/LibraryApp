# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require 'minitest/unit'
require 'mocha/minitest'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def is_logged_in?
      !session[:staff_id].nil?
    end

    def log_in_as(staff)
      post login_path, params: { session: { username: staff.username, password: 'password' } }
    end
  end
end
