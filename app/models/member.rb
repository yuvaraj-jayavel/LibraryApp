class Member < ApplicationRecord
  include PgSearch::Model
  include Filterable

  has_many :book_rentals

  validates :name, presence: true
  validates :personal_number, presence: true, uniqueness: true, numericality: { greater_than: 0 }

  validates :phone, length: { is: 10 }, uniqueness: true, allow_blank: true

  pg_search_scope :search_by_name,
                  against: %i[name],
                  using: {
                    tsearch: { prefix: true }
                  }

  # filter only members who have less than the maximum allowed current book rentals
  scope :can_rent, -> { where( id: joins('LEFT JOIN book_rentals ON members.id = book_rentals.member_id AND book_rentals.returned_on IS NULL').group('members.id').having("COUNT(book_rentals.id) < #{BookRental::MAX_RENTALS} OR COUNT(book_rentals.id) IS NULL").merge(BookRental.current) ) }

  "select id from members m left joins book_rentals br on m.id = br.member_id where br.returned_on is null group by m.id having count(br.id) <= #{BookRental::MAX_RENTALS}"

  def self.search_by_id(search_id)
    Member.where(id: search_id).or(Member.where(personal_number: search_id))
  end

  def self.filter_by_can_rent(filter_can_rent = false)
    case filter_can_rent
    when 'true', true
      can_rent
    else
      all
    end
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
