class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, inclusion: { in: ["customer", "admin"] }
  
  has_one :cart, dependent: :destroy
end
