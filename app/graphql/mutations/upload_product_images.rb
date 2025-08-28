# app/graphql/mutations/upload_product_images.rb
module Mutations
  class UploadProductImages < BaseMutation
    argument :product_id, ID, required: true
    argument :images, [Types::UploadType], required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: false

    def resolve(product_id:, images:)
      product = Product.find_by(id: product_id)
      return { product: nil, errors: ["Product not found"] } unless product

      images.each do |image|
        if image.respond_to?(:tempfile)
          product.images.attach(
            io: image.tempfile, 
            filename: image.original_filename, 
            content_type: image.content_type
          )
        elsif image.is_a?(ActionDispatch::Http::UploadedFile)
          product.images.attach(image)
        end
      end

      { product: product.reload, errors: [] }
    rescue => e
      { product: nil, errors: [e.message] }
    end
  end
end
