class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }
  
  # Set default quantity if not provided
  after_initialize do
    self.quantity ||= 1 if new_record?
  end
end