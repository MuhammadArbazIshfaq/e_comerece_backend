class Product < ApplicationRecord
  has_many :categories_products
  has_many :categories, through: :categories_products
    has_many_attached :images
end