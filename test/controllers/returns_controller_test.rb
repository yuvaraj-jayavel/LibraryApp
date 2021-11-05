require 'test_helper'

class ReturnsControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get new_return_path
    assert_response :success
  end
end
