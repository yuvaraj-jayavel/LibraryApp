class BookRental < ApplicationRecord
  belongs_to :book
  belongs_to :member

  def borrower
    "#{member.name} ##{member.id}"
  end

  def borrowed_book
    "#{book.name} ##{book.id}"
  end
end
