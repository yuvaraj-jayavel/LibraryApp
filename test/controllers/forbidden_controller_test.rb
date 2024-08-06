class ForbiddenControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get forbidden_path
    assert_redirected_to login_path
  end
end
