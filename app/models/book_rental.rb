class BookRental < ApplicationRecord
  belongs_to :book
  belongs_to :member

  validate :book_is_available, on: :create

  def borrower
    "#{member.name} ##{member.id}"
  end

  def borrowed_book
    "#{book.name} ##{book.id}"
  end

  private

  def book_is_available
    errors.add(:book, 'should be available') unless book.available?
  end
end
