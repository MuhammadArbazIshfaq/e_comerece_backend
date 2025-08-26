module Mutations
  class DeleteProduct < BaseMutation
    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(id:)
      authorize_admin!

      product = Product.find_by(id: id)
      return { success: false, errors: ["Product not found"] } unless product

      if product.destroy
        { success: true, errors: [] }
      else
        { success: false, errors: product.errors.full_messages }
      end
    end
  end
end
