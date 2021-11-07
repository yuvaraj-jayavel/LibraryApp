require "test_helper"

class MembersControllerTest < ActionDispatch::IntegrationTest
  test 'should not be able to get index when not logged in' do
    assert_raises Pundit::NotAuthorizedError do
      get members_path
    end
  end

  test 'should not be able to get new page when not logged in' do
    assert_raises Pundit::NotAuthorizedError do
      get new_member_path
    end
  end

  test 'should not be able to create new member when not logged in' do
    assert_raises Pundit::NotAuthorizedError do
      post members_path
    end
  end

  test 'should be able to get index when logged in' do
    log_in_as staffs(:admino)
    assert_nothing_raised do
      get members_path
      assert_response :success
    end
  end

  test 'should be able to get new page when logged in' do
    log_in_as staffs(:admino)
    assert_nothing_raised do
      get new_member_path
      assert_response :success
    end
  end

  test 'should be able to create new member when logged in' do
    log_in_as staffs(:admino)
    assert_nothing_raised do
      post members_path, params: { member: { name: 'New Member', personal_number: 1234 } }
      assert_response :redirect
    end
  end
end
