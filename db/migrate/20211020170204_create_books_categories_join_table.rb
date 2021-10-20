# frozen_string_literal: true

class CreateBooksCategoriesJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :books, :categories do |t|
      t.index :category_id
      t.index :book_id
    end
  end
end
