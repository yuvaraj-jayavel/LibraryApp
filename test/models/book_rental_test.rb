require "test_helper"

class BookRentalTest < ActiveSupport::TestCase
  test 'due_by should be equal to DUE_BY_DAYS + issued_on date' do
    issued_on = Date.today
    book_rental = BookRental.new(
      book: books(:unborrowed),
      member: members(:johnny),
      issued_on: issued_on
    )

    assert_equal issued_on + BookRental::DUE_BY_DAYS, book_rental.due_by
  end

  test 'fine should be zero if the book has already been returned' do
    book_rental = book_rentals(:returned)
    assert_equal 0, book_rental.fine
  end

  test 'fine should be zero if due_by is today or in future' do
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

  test 'fine should be equal to (returning_on - due_by) multiplied by FINE_PER_DAY' do
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
end
