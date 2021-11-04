class ChangeDataTypeForIssuedAtAndReturnedAtInBookRentals < ActiveRecord::Migration[6.1]
  def change
    rename_column :book_rentals, :issued_at, :issued_on
    change_column :book_rentals, :issued_on, :date

    rename_column :book_rentals, :returned_at, :returned_on
    change_column :book_rentals, :returned_on, :date
  end
end
