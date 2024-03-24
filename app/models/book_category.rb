class BookCategory < ApplicationRecord
  # Model Column Definition
  # t.bigint "book_id", null: false
  # t.bigint "category_id", null: false
  # t.datetime "created_at", precision: 6, null: false
  # t.datetime "updated_at", precision: 6, null: false
  # t.index ["book_id"], name: "index_book_categories_on_book_id"
  # t.index ["category_id"], name: "index_book_categories_on_category_id"

  belongs_to :book
  belongs_to :category
end
