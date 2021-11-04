class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.string :name
      t.string :father_name
      t.integer :personal_number
      t.date :date_of_birth
      t.date :date_of_retirement
      t.string :email
      t.string :phone

      t.timestamps
    end
    add_index :members, :personal_number, unique: true
    add_index :members, :email, unique: true
    add_index :members, :phone, unique: true
  end
end
