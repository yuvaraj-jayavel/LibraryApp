# frozen_string_literal: true

class Publisher < ApplicationRecord
  # Model Column Definition
  # t.text "name"
  # t.datetime "created_at", precision: 6, null: false
  # t.datetime "updated_at", precision: 6, null: false

  validates :name, presence: true
end
