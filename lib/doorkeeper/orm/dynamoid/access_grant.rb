require 'doorkeeper-dynamodb/compatible'

module Doorkeeper
  class AccessGrant
    include DoorkeeperDynamodb::Compatible
    include Dynamoid::Document
    include AccessGrantMixin

    table name: :oauth_access_grants, key: :resource_owner_id, read_capacity: 5, write_capacity: 5

    field :application_id,    :serialized
    field :scopes,            :string
    field :expires_in,        :integer
    field :redirect_uri,      :string
    field :revoked_at,        :datetime
  end
end
