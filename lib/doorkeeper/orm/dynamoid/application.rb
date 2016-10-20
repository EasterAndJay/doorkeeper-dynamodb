module Doorkeeper
  class Application
    include Dynamoid::Document

    include ApplicationMixin
    table name: :oauth_applications, key: :uid, read_capacity: 5, write_capacity: 5

    has_many :authorized_tokens, class: Doorkeeper::AccessToken

    field :uid,          :string
    field :name,         :string
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
  end
end
