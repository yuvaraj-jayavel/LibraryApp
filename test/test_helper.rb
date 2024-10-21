# frozen_string_literal: true

require 'simplecov'
# Fastcov.start
#   add_group "Model", "app/models"
#   add_group "Controller", "app/controllers"
#   add_group "Helper", "app/helpers"
#   add_group "Channel", "app/channels"
#   add_group "Job", "app/jobs"
#   add_group "Policy", "app/policies"
#   add_group "Mailer", "app/mailers"
# end
ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
require 'simplecov-csv'
require 'simplecov_json_formatter'

SimpleCov.formatters =
  if ENV['JENKINS'] || ENV['CIRCLECI']
    [SimpleCov::Formatter::JSONFormatter]
  else
    [
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::CSVFormatter,
      SimpleCov::Formatter::JSONFormatter
    ]
  end

SimpleCov.start 'rails' do
  # Unique command_name helps in coverage-merging esp. during failed tests rerun
  command_name "#{SimpleCov::CommandGuesser.guess}-#{Time.now.to_i}"

  # If CCI, 3 days (workspace retention period) to handle failed tests rerun; Else, 1 hour
  merge_timeout (ENV['CIRCLECI'] ? 259200 : 3600) # in seconds

  add_filter "/vendor/gems/"
  add_filter "/vendor/assets/"
  add_filter "/vendor/plugins/"
  add_filter "/app/assets/"
  add_filter "/lib/tasks/single_time/"
  add_filter "/lib/performance_quality_gate/"
  add_filter "/lib/tasks/performance_quality_gate/"
  add_filter "/script/"
  add_filter "/lib/messages_splitup/"
end
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
