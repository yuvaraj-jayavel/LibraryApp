class AddCustomNumberToBookAndMember < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :custom_number, :string
    add_column :members, :custom_number, :string

    add_index :books, :custom_number, unique: true
    add_index :members, :custom_number, unique: true
  end
end
