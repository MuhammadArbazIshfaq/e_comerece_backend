module Mutations
  class UpdateProduct < BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: false
    argument :description, String, required: false
    argument :price, Float, required: false
    argument :stock, Integer, required: false
    argument :category_ids, [ID], required: false  # multiple categories

    field :product, Types::ProductType, null: true
    field :errors, [String], null: false

    def resolve(id:, **attributes)
      authorize_admin!  # ensure only admin can update

      product = Product.find_by(id: id)
      return { product: nil, errors: ["Product not found"] } unless product

      category_ids = attributes.delete(:category_ids)

      begin
        ActiveRecord::Base.transaction do
          product.update!(attributes.compact)

          if category_ids
            product.categories = Category.where(id: category_ids)
          end
        end

        { product: product, errors: [] }
      rescue => e
        { product: nil, errors: [e.message] }
      end
    end
  end
end
