require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get books_path
    assert_response :success
  end

  test 'should not be able to access new book page when not logged in' do
    assert_raises Pundit::NotAuthorizedError do
      get new_book_path
    end
  end

  test 'should not be able to create new book when not logged in' do
    assert_raises Pundit::NotAuthorizedError do
      post books_path
    end
  end

  test 'should be able to access index page when not logged in' do
    get books_path
    assert_response :success
  end
end
