require "test_helper"

class StaffLoginTest < ActionDispatch::IntegrationTest
  test "login with invalid credentials" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { username: '', password: '' } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end