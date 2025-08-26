# app/graphql/mutations/update_category.rb
module Mutations
  class UpdateCategory < BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: false

    field :category, Types::CategoryType, null: true
    field :errors, [String], null: false

    def resolve(id:, name:)
      category = Category.find_by(id: id)
      return { category: nil, errors: ["Not found"] } unless category

      if category.update(name: name)
        { category: category, errors: [] }
      else
        { category: nil, errors: category.errors.full_messages }
      end
    end
  end
end
