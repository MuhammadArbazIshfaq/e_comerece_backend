module Types
  class CheckoutInput < Types::BaseInputObject
    argument :shipping_address, String, required: false
    argument :payment_method, String, required: false
    argument :notes, String, required: false
  end
end
