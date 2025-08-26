class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many_attached :images

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
