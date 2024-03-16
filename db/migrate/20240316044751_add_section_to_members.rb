class AddSectionToMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :section, :string
  end
end
