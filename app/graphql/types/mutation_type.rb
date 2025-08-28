module Types
  class MutationType < Types::BaseObject
    field :signup_user, mutation: Mutations::SignupUser
    field :login_user, mutation: Mutations::LoginUser
    field :logout_user, mutation: Mutations::LogoutUser
    field :create_product, mutation: Mutations::CreateProduct
    field :create_category, mutation: Mutations::CreateCategory
    field :update_product, mutation: Mutations::UpdateProduct
    field :delete_product, mutation: Mutations::DeleteProduct
    field :update_category, mutation: Mutations::UpdateCategory
    field :delete_category, mutation: Mutations::DeleteCategory
    field :upload_product_images, mutation: Mutations::UploadProductImages
    field :add_to_cart, mutation: Mutations::AddToCart
    field :remove_from_cart, mutation: Mutations::RemoveFromCart
    field :update_cart_item, mutation: Mutations::UpdateCartItem
    field :checkout, mutation: Mutations::Checkout
    field :update_order_status, mutation: Mutations::UpdateOrderStatus

  end
end
