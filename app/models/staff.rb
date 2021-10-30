class Staff < ApplicationRecord
  belongs_to :role

  has_secure_password

  def admin?
    role.name == 'ADMIN'
  end

  def librarian?
    role.name == 'LIBRARIAN'
  end
end
