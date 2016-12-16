require 'doorkeeper-dynamodb/compatible'

module Doorkeeper
  class AccessGrant
    include DoorkeeperDynamodb::Compatible
    include OAuth::Helpers
    include Models::Expirable
    include Models::Revocable
    include Models::Accessible
    include Models::Scopes

    include ::Dynamoid::Document
    table name: :oauth_access_grants
    field :resource_owner_id, :string
    field :scopes,            :string
    field :expires_in,        :integer
    field :redirect_uri,      :string
    field :refresh_token,     :string

    range :revoked_at,        :datetime
    range :created_at,        :datetime
    range :updated_at,        :datetime

    # belongs_to :application, class_name: 'Doorkeeper::Application', :inverse_of => :grants
  end
end
