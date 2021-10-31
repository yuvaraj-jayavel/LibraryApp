require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @staff = staffs(:admino)
    remember(@staff)
  end

  test 'current_staff returns correct staff when session is nil' do
    assert_equal @staff, current_staff
    assert is_logged_in?
  end

  test 'current_staff returns nil when remember digest is wrong' do
    @staff.update_attribute(:remember_digest, Staff.digest(Staff.new_token))
    assert_nil current_staff
  end
end