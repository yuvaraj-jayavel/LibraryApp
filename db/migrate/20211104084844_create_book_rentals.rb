class CreateBookRentals < ActiveRecord::Migration[6.1]
  def change
    create_table :book_rentals do |t|
      t.references :book, null: false, foreign_key: true
      t.references :member, null: false, foreign_key: true
      t.datetime :issued_at, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :returned_at

      t.timestamps
    end
  end
end
