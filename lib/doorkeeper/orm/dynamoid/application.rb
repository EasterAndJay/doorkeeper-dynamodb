module Doorkeeper
  class Application
    include Dynamoid::Document

    include ApplicationMixin

    safe
    timestamps!

    set_collection_name 'oauth_applications'

    many :authorized_tokens, class_name: 'Doorkeeper::AccessToken'

    field :name,         :string
    field :uid,          :string
    field :secret,       :string
    field :redirect_uri, :string
    field :scopes,       :string

    def self.authorized_for(resource_owner)
      ids = AccessToken.where(
          resource_owner_id: resource_owner.id,
          revoked_at: nil
        ).map(&:application_id)
      find(ids)
    end

    def self.create_indexes
      ensure_index :uid, unique: true
    end
  end
end
