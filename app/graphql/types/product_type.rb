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
        object.images.map do |img|
          if Rails.env.development?
            "http://localhost:3000#{Rails.application.routes.url_helpers.rails_blob_path(img, only_path: true)}"
          else
            Rails.application.routes.url_helpers.url_for(img)
          end
        end
      else
        []
      end
    end
  end
end
