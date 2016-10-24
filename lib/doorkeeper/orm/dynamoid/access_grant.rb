require 'doorkeeper-dynamodb/compatible'

module Doorkeeper
  class AccessGrant
    include DoorkeeperDynamodb::Compatible

    include Dynamoid::Document
    table name: :oauth_access_grants, key: :token, read_capacity: 5, write_capacity: 5
    field :application_id,    :serialized
    field :resource_owner_id, :serialized
    field :scopes,            :string
    field :expires_in,        :integer
    field :redirect_uri,      :string
    field :revoked_at,        :datetime

    include OAuth::Helpers
    include Models::Expirable
    include Models::Revocable
    include Models::Accessible
    include Models::Scopes
    include ActiveModel::MassAssignmentSecurity if defined?(::ProtectedAttributes)
    belongs_to :client, class_name: 'Doorkeeper::Application'
    validates :resource_owner_id, :application_id, :token, :expires_in, :redirect_uri, presence: true

    module ClassMethods
      def by_token(token)
        find_by(token: token.to_s)
      end
    end
  end
end
