require "test_helper"

class BookRentalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get book_rentals_path
    assert_response :success
  end

  test 'should create book rental if book is available' do
    available_book = book_rentals(:returned).book
    member = members(:johnny)

    get new_book_rental_path
    assert_response :success

    assert_difference 'BookRental.count' do
      post book_rentals_path,
           params: {
             book_rental: {
               book_id: available_book.id,
               member_id: member.id,
               issued_on: Date.today.to_formatted_s
             }
           }
      assert_response :redirect
      follow_redirect!
      assert_template 'book_rentals/index'
      assert flash.empty?
    end
  end

  test 'should not create book rental if book is unavailable' do
    unavailable_book = book_rentals(:unreturned).book
    member = members(:johnny)

    get new_book_rental_path
    assert_response :success

    assert_no_difference 'BookRental.count' do
      post book_rentals_path,
           params: {
             book_rental: {
               book_id: unavailable_book.id,
               member_id: member.id,
               issued_on: Date.today.to_formatted_s
             }
           }
      assert_template 'book_rentals/new'
      assert_not flash.empty?
      get root_path
      assert flash.empty?
    end
  end
end
