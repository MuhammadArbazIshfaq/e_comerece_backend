module Types
  class ProductType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String, null: true
    field :price, Float, null: false
    field :stock, Integer, null: false
    field :categories, [Types::CategoryType], null: true
    field :image_urls, [String], null: true

    def image_urls
      if object.images.attached?
        object.images.map { |img| Rails.application.routes.url_helpers.url_for(img) }
      else
        []
      end
    end
  end
end
