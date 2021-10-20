# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :author
  belongs_to :publisher, optional: true
  has_and_belongs_to_many :categories

  validates :name, presence: true
  validates :publishing_year, numericality: { allow_nil: true, less_than_or_equal_to: Time.now.year }
end
