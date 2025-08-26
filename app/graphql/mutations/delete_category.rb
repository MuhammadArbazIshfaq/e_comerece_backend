# app/graphql/mutations/delete_category.rb
module Mutations
  class DeleteCategory < BaseMutation
    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(id:)
      category = Category.find_by(id: id)
      return { success: false, errors: ["Not found"] } unless category

      if category.destroy
        { success: true, errors: [] }
      else
        { success: false, errors: category.errors.full_messages }
      end
    end
  end
end
