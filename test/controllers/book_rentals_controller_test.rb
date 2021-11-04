require "test_helper"

class BookRentalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get book_rentals_index_url
    assert_response :success
  end
end
