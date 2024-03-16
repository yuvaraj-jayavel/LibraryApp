class RenameFathersNameToTamilNameInMembers < ActiveRecord::Migration[6.1]
  def change
    rename_column :members, :father_name, :tamil_name
  end
end
