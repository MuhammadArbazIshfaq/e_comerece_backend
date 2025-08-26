module Mutations
  class UpdateProduct < BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: false
    argument :description, String, required: false
    argument :price, Float, required: false
    argument :category_id, ID, required: false

    field :product, Types::ProductType, null: true
    field :errors, [String], null: false

    def resolve(id:, **attributes)
      authorize_admin!

      product = Product.find_by(id: id)
      return { product: nil, errors: ["Product not found"] } unless product

      if product.update(attributes.compact)
        { product: product, errors: [] }
      else
        { product: nil, errors: product.errors.full_messages }
      end
    end
  end
end
