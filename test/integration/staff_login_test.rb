require 'test_helper'

class StaffLoginTest < ActionDispatch::IntegrationTest
  def setup
    @admin_staff = staffs(:admino)
  end

  test 'login with invalid credentials' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { username: '', password: '' } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'root path navbar contains correct login links' do
    get root_path
    assert_template 'books/index'
    # Should contain login link before being logged in
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, 0

    post login_path, params: { session: { username: @admin_staff.username, password: 'password' } }
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'books/index'
    # Should contain logout link after being logged in
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', login_path, count: 0
  end

  test 'login with valid credentials followed by logout' do
    get login_path
    post login_path, params: { session: { username: @admin_staff.username, password: 'password' } }
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'books/index'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
  end
end
