class BookRental < ApplicationRecord
  include PgSearch::Model

  DUE_BY_DAYS = 15
  FINE_PER_DAY = 1

  belongs_to :book
  belongs_to :member

  validate :book_is_available, on: :create

  scope :current, -> { where(returned_on: nil) }

  pg_search_scope :search,
                  associated_against: {
                    book: :name,
                    member: :name
                  },
                  using: {
                    tsearch: { prefix: true }
                  }

  def borrower
    "#{member.name} ##{member.id}"
  end

  def borrowed_book
    "#{book.name} ##{book.id}"
  end

  def returned?
    !returned_on.nil?
  end

  def due_by
    issued_on + DUE_BY_DAYS.days
  end

  def fine(returned_on = Date.today)
    if returned? || due_by >= returned_on
      0
    else
      ((returned_on - due_by) * FINE_PER_DAY).to_f
    end
  end

  private

  def book_is_available
    errors.add(:book, 'should be available') unless book.available?
  end
end
