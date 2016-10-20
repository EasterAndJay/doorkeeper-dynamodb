require 'doorkeeper-dynamodb/compatible'

module Doorkeeper
  class AccessToken
    include DoorkeeperDynamodb::Compatible

    include Dynamoid::Document

    include AccessTokenMixin

    safe
    timestamps!

    set_collection_name 'oauth_access_tokens'

    field :resource_owner_id, :serialized
    field :application_id,    :serialized
    field :token,             :string
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

    def self.create_indexes
      ensure_index :token, unique: true
      ensure_index [[:refresh_token, 1]], unique: true, sparse: true
    end

    def self.order_method
      :sort
    end

    def self.created_at_desc
      :created_at.desc
    end
  end
end
