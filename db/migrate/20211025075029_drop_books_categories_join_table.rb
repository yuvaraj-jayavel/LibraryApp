class DropBooksCategoriesJoinTable < ActiveRecord::Migration[6.1]
  def change
    drop_join_table :books, :categories
  end
end
