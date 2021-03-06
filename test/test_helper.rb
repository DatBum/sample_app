require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"

class ActiveSupport
  class TestCase; end
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def is_logged_in?
    session[:user_id].present?
  end

  def log_in_as user
    session[:user_id] = user.id
  end
end
