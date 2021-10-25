class AlterPublisherColumnToNullableInBooks < ActiveRecord::Migration[6.1]
  def change
    change_column_null :books, :publisher_id, true
  end
end
