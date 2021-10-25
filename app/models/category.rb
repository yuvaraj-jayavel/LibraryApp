# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :book_categories
  has_many :books, through: :book_categories

  validates :name, presence: true
end
