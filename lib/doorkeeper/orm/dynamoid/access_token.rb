require 'doorkeeper-dynamodb/compatible'

module Doorkeeper
  class AccessToken
    include DoorkeeperDynamodb::Compatible

    include Dynamoid::Document

    include AccessTokenMixin
    table name: :oauth_access_tokens, key: :token, read_capacity: 5, write_capacity: 5

    field :resource_owner_id, :serialized
    field :application_id,    :serialized
    field :refresh_token,     :string
    field :expires_in,        :integer
    field :revoked_at,        :datetime
    field :scopes,            :string

    def self.last
      self.sort(:created_at).last
    end

    def self.delete_all_for(application_id, resource_owner)
      delete_all(application_id: application_id,
                 resource_owner_id: resource_owner.id)
    end
    private_class_method :delete_all_for

    def self.order_method
      :sort
    end

    def self.created_at_desc
      :created_at.desc
    end
  end
end
