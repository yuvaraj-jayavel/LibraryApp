# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :author
  belongs_to :publisher, optional: true
  has_many :book_categories
  has_many :categories, through: :book_categories

  validates :name, presence: true
  validates :publishing_year, numericality: { allow_nil: true, less_than_or_equal_to: Time.now.year }
  validates :author_id, presence: true

  # before_validation :strip_and_squish_whitespaces
  #
  # def strip_and_squish_whitespaces
  #   self.name = name.strip.gsub(/\s+/, ' ') if name.respond_to?('strip')
  # end

  def self.create_with_associated_models(hash = {})
    Book.transaction do
      author = Author.find_or_create_by(name: hash[:author_name])
      publisher = Publisher.find_or_create_by(name: hash[:publisher_name])
      categories = hash[:categories]&.split(',')&.map do |category_name|
        Category.find_or_create_by(name: category_name)
      end || []
      @new_book = Book.create(name: hash[:name], author: author, publisher: publisher,
                          publishing_year: hash[:publishing_year], categories: categories)
      raise ActiveRecord::Rollback if @new_book.invalid?

    end
    @new_book
  end
end
