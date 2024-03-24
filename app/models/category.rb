# frozen_string_literal: true

class Category < ApplicationRecord
  # Model Column Definition
  # t.text "name"
  # t.datetime "created_at", precision: 6, null: false
  # t.datetime "updated_at", precision: 6, null: false

  has_many :book_categories
  has_many :books, through: :book_categories

  validates :name, presence: true
end
