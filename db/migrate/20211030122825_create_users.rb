class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :member_id
      t.string :name
      t.string :phone
      t.string :email
      t.references :role, null: false, foreign_key: true
      t.string :password_digest

      t.timestamps
    end
  end
end
