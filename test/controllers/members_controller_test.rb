require "test_helper"

class MembersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get members_path
    assert_response :success
  end
end
