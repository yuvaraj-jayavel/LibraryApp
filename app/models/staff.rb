class Staff < ApplicationRecord
  # Model Column Definition
  # t.string "username"
  # t.string "password_digest"
  # t.bigint "role_id", null: false
  # t.datetime "created_at", precision: 6, null: false
  # t.datetime "updated_at", precision: 6, null: false
  # t.string "remember_digest"
  # t.index ["role_id"], name: "index_staffs_on_role_id"

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

  def forget
    update_attribute(:remember_digest, nil)
  end

  def admin?
    role&.name == 'ADMIN'
  end

  def librarian?
    role&.name == 'LIBRARIAN'
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest) == remember_token if remember_digest.present?
  rescue BCrypt::Errors::InvalidHash
    false
  end
end
