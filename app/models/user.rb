class User < ApplicationRecord
  belongs_to :role

  has_secure_password

  validates :member_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true, allow_blank: true
  validates :phone, length: { is: 10 }, format: { with: /\A\d+\z/ }, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
end
