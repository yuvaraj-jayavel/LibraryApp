require "test_helper"

class BookRentalTest < ActiveSupport::TestCase
  def test_due_by_should_be_equal_to_DUE_BY_DAYS_issued_on_date
    issued_on = Date.today
    book_rental = BookRental.new(
      book: books(:unborrowed),
      member: members(:johnny),
      issued_on: issued_on
    )

    assert_equal issued_on + BookRental::DUE_BY_DAYS, book_rental.due_by
  end

  def test_fine_should_be_zero_if_the_book_has_already_been_returned
    book_rental = book_rentals(:returned)
    assert_equal 0, book_rental.fine
  end

  def test_fine_should_be_zero_if_due_by_is_today_or_in_future
    book_rental = BookRental.new(
      book: books(:unborrowed),
      member: members(:johnny),
      issued_on: Date.today # this ensures due_by will be in the future
    )
    assert_operator book_rental.due_by, :>, Date.today
    assert_equal 0, book_rental.fine

    book_rental.issued_on = Date.today - BookRental::DUE_BY_DAYS
    assert_equal Date.today, book_rental.due_by
    assert_equal 0, book_rental.fine
  end

  def test_fine_should_be_equal_to_returning_on_due_by_multiplied_by_FINE_PER_DAY
    returning_on = 2.days.ago.to_date
    days_elapsed_after_due_by = 5
    # e.g. issued_on = Today - (15 + 5)
    issued_on = returning_on - (BookRental::DUE_BY_DAYS + days_elapsed_after_due_by)
    book_rental = BookRental.new(
      book: books(:unborrowed),
      member: members(:johnny),
      issued_on: issued_on
    )

    assert_equal (returning_on - book_rental.due_by) * BookRental::FINE_PER_DAY, book_rental.fine(returning_on)
    assert book_rental.fine.instance_of? Float
  end

  def test_search_should_match_book_rental_by_book_name
    book_rental = book_rentals(:unreturned)
    assert_includes BookRental.search(book_rental.book.name), book_rental
  end

  def test_search_should_match_book_rental_by_partial_book_name
    book_rental = book_rentals(:unreturned)
    assert_includes BookRental.search(book_rental.book.name[..-2]), book_rental
  end

  def test_search_should_match_book_rental_by_member_name
    book_rental = book_rentals(:unreturned)
    assert_includes BookRental.search(book_rental.member.name), book_rental
  end

  def test_search_should_match_book_rental_by_partial_member_name
    book_rental = book_rentals(:unreturned)
    assert_includes BookRental.search(book_rental.member.name[..-2]), book_rental
  end

  def test_empty_search_query_should_return_all_book_rentals
    search_results = BookRental.search('')
    assert_equal BookRental.all, search_results
  end

  def test_filter_by_show_all_should_return_all_rented_out_rentals_when_called_with_string_true
    filter_results = BookRental.filter_by_show_all('true')
    assert_equal BookRental.all, filter_results
  end

  def test_filter_by_show_all_should_return_all_rented_out_rentals_when_called_with_boolean_true
    filter_results = BookRental.filter_by_show_all(true)
    assert_equal BookRental.all, filter_results
  end

  def test_filter_by_show_all_should_return_only_current_rentals_when_called_with_string_false
    filter_results = BookRental.filter_by_show_all('false')
    assert_equal BookRental.current, filter_results
  end

  def test_filter_by_show_all_should_return_all_rentals_when_called_with_boolean_true
    filter_results = BookRental.filter_by_show_all(true)
    assert_equal BookRental.all, filter_results
  end

  def test_filter_by_show_all_should_return_only_current_rentals_when_called_with_blank_values
    filter_results = BookRental.filter_by_show_all(nil)
    assert_equal BookRental.current, filter_results

    filter_results = BookRental.filter_by_show_all('')
    assert_equal BookRental.current, filter_results
  end
end

