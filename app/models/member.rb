class Member < ApplicationRecord
  include PgSearch::Model

  has_many :book_rentals

  validates :name, presence: true
  validates :personal_number, presence: true, uniqueness: true, numericality: { greater_than: 0 }

  validates :phone, length: { is: 10 }, uniqueness: true, allow_blank: true

  pg_search_scope :search_by_name,
                  against: %i[name],
                  using: {
                    tsearch: { prefix: true }
                  }

  def self.search_by_id(search_id)
    Member.where(id: search_id).or(Member.where(personal_number: search_id))
  end

  def self.search(query, max_results = nil)
    if /^\d+$/.match(query.to_s)
      search_by_id(query).limit(max_results)
    elsif query.present?
      search_by_name(query).limit(max_results)
    else
      all.limit(max_results)
    end
  end
end
