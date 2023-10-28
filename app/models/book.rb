# frozen_string_literal: true

class Book < ApplicationRecord
  include PgSearch::Model
  include Filterable

  belongs_to :author, optional: true
  belongs_to :publisher, optional: true
  has_many :book_categories
  has_many :categories, through: :book_categories
  has_many :book_rentals

  attr_accessor :category_names

  validates :name, presence: true
  validates :publishing_year, numericality: { allow_nil: true, less_than_or_equal_to: Time.now.year }

  pg_search_scope :search_by_name,
                  against: %i[name],
                  associated_against: {
                    author: :name
                  },
                  using: {
                    tsearch: { prefix: true }
                  }

  # acts like a scope
  def self.available
    where.not(id: joins(:book_rentals).where(book_rentals: { returned_on: nil }))
  end

  def self.unavailable
    where(id: joins(:book_rentals).where(book_rentals: { returned_on: nil }))
  end

  def self.filter_by_availability(availability)
    case availability
    when 'true', true
      available
    when 'false', false
      unavailable
    else
      all
    end
  end

  def self.search_by_id(search_id)
    where(id: search_id)
  end

  def self.search(query, max_results=nil)
    if /^\d+$/.match(query.to_s)
      search_by_id(query).limit(max_results)
    elsif query.present?
      search_by_name(query).limit(max_results)
    else
      all.limit(max_results)
    end
  end

  def self.create_with_associated_models(hash = {})
    Book.transaction do
      author = Author.find_or_create_by(name: hash[:author_name])
      publisher = Publisher.find_or_create_by(name: hash[:publisher_name])
      categories = hash[:category_names]&.split(',')&.map do |category_name|
        Category.find_or_create_by(name: category_name.strip)
      end || []
      @new_book = Book.create(name: hash[:name], author: author, publisher: publisher,
                              publishing_year: hash[:publishing_year], categories: categories)
      raise ActiveRecord::Rollback if @new_book.invalid?

    end
    @new_book
  end

  def available?
    !BookRental.exists?(book_id: id, returned_on: nil)
  end
end
