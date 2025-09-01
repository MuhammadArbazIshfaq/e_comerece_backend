module Mutations
  class DeleteProduct < BaseMutation
    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(id:)
      authorize_admin!

      product = Product.find_by(id: id)
      return { success: false, errors: ["Product not found"] } unless product

      begin
        ActiveRecord::Base.transaction do
          # Remove all category associations first
          product.categories.clear
          
          # Remove all cart items that reference this product
          CartItem.where(product: product).destroy_all
          
          # Remove Active Storage attachments (images)
          product.images.purge if product.images.attached?
          
          # Remove all order items that reference this product
          # Note: This removes order history - consider if you want this
          OrderItem.where(product: product).destroy_all
          
          # Now safely delete the product
          product.destroy!
        end
        
        { success: true, errors: [] }
      rescue ActiveRecord::RecordInvalid => e
        { success: false, errors: e.record.errors.full_messages }
      rescue ActiveRecord::InvalidForeignKey => e
        { success: false, errors: ["Cannot delete product due to foreign key constraint: #{e.message}"] }
      rescue StandardError => e
        { success: false, errors: ["Failed to delete product: #{e.message}"] }
      end
    end

    private

  end
end