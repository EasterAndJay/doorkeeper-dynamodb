require 'doorkeeper-dynamodb/compatible'

module Doorkeeper
  class AccessGrant
    include DoorkeeperDynamodb::Compatible
    include Dynamoid::Document
    include AccessGrantMixin

    set_collection_name 'oauth_access_grants'

    field :resource_owner_id, :serialized
    field :application_id,    :serialized
    field :scopes,            :string
    field :expires_in,        :integer
    field :redirect_uri,      :string
    field :revoked_at,        :datetime
  end
end
