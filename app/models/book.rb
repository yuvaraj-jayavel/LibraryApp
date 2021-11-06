# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :author
  belongs_to :publisher, optional: true
  has_many :book_categories
  has_many :categories, through: :book_categories
  has_many :book_rentals

  validates :name, presence: true
  validates :publishing_year, numericality: { allow_nil: true, less_than_or_equal_to: Time.now.year }
  validates :author_id, presence: true

  def self.create_with_associated_models(hash = {})
    Book.transaction do
      author = Author.find_or_create_by(name: hash[:author_name])
      publisher = Publisher.find_or_create_by(name: hash[:publisher_name])
      categories = hash[:categories]&.split(',')&.map do |category_name|
        Category.find_or_create_by(name: category_name.strip)
      end || []
      @new_book = Book.create(name: hash[:name], author: author, publisher: publisher,
                              publishing_year: hash[:publishing_year], categories: categories)
      raise ActiveRecord::Rollback if @new_book.invalid?

    end
    @new_book
  end

  def self.available
    where.not(id: joins(:book_rentals).where(book_rentals: { returned_on: nil }))
  end

  def available?
    !BookRental.exists?(book_id: id, returned_on: nil)
  end
end
