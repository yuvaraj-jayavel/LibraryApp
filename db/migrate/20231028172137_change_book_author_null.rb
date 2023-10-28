class ChangeBookAuthorNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :books, :author_id, true
  end
end
