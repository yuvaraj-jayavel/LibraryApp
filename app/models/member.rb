class Member < ApplicationRecord
  validates :name, presence: true
  validates :personal_number, presence: true, uniqueness: true, numericality: { greater_than: 0 }

  validates :phone, length: { allow_blank: true, is: 10 }
end