class Staff < ApplicationRecord
  attr_accessor :remember_token
  
  belongs_to :role

  has_secure_password

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = Staff.new_token
    update_attribute(:remember_digest, Staff.digest(remember_token))
  end

  def admin?
    role&.name == 'ADMIN'
  end

  def librarian?
    role&.name == 'LIBRARIAN'
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest) == remember_token
  end
end
