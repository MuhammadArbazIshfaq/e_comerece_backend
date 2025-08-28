module Types
  class UploadType < Types::BaseScalar
    description "A file upload"

    def self.coerce_input(value, _ctx)
      value # This will be an ActionDispatch::Http::UploadedFile
    end

    def self.coerce_result(value, _ctx)
      value
    end
  end
end
