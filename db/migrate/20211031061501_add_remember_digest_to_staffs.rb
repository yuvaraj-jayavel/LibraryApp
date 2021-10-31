class AddRememberDigestToStaffs < ActiveRecord::Migration[6.1]
  def change
    add_column :staffs, :remember_digest, :string
  end
end
