module Mutations
  class CreateProduct < BaseMutation
    argument :name, String, required: true
    argument :description, String, required: false
    argument :price, Float, required: true
    argument :stock, Integer, required: true
    argument :category_ids, [ID], required: false

    field :product, Types::ProductType, null: true
    field :errors, [String], null: false

    def resolve(name:, price:, stock:, description: nil, category_ids: [])
      authorize_admin!
      product = Product.new(
        name: name,
        description: description,
        price: price,
        stock: stock,
        categories: Category.where(id: category_ids)
      )

      if product.save
        { product: product, errors: [] }
      else
        { product: nil, errors: product.errors.full_messages }
      end
    end
  end
end
