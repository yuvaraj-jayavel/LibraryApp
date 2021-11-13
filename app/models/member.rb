class Member < ApplicationRecord
  include PgSearch::Model

  has_many :book_rentals

  validates :name, presence: true
  validates :personal_number, presence: true, uniqueness: true, numericality: { greater_than: 0 }

  validates :phone, length: { allow_blank: true, is: 10 }

  pg_search_scope :search_by_name,
                  against: %i[name],
                  using: {
                    tsearch: { prefix: true }
                  }

  def self.search_by_id(search_id)
    Member.where(id: search_id).or(Member.where(personal_number: search_id))
  end
end
