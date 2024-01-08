class ApplicationSerializer
    include JSONAPI::Serializer

    cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 1.hour

    attributes :created_at, :updated_at
end