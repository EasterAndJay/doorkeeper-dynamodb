require 'doorkeeper-dynamodb/compatible'

module Doorkeeper
  class Application
    include DoorkeeperDynamodb::Compatible
    include OAuth::Helpers
    include Models::Expirable
    include Models::Revocable
    include Models::Accessible
    include Models::Scopes

    include Dynamoid::Document
    table name: :oauth_applications, key: :uid, read_capacity: 5, write_capacity: 5
    has_many :authorized_tokens, class_name: 'Doorkeeper::AccessToken'
    has_many :access_grants, dependent: :delete_all, class_name: 'Doorkeeper::AccessGrant'
    has_many :access_tokens, dependent: :delete_all, class_name: 'Doorkeeper::AccessToken'

    field :name,         :string
    field :secret,       :string
    field :redirect_uri, :string
    field :scopes,       :string
    validates :name, :secret, presence: true
    validates :redirect_uri, redirect_uri: true

    before_validation :generate_secret, on: :create

    class << self
      def authorized_for(resource_owner)
        ids = AccessToken.where(
            resource_owner_id: resource_owner.id,
            revoked_at: nil
          ).map(&:application_id)
        find(ids)
      end

      def by_uid_and_secret(uid, secret)
        find_by(uid: uid.to_s, secret: secret.to_s)
      end

      def by_uid(uid)
        find_by(uid: uid.to_s)
      end
    end

    def id
      uid
    end

    private

    def has_scopes?
      Doorkeeper.configuration.orm != :active_record ||
        Doorkeeper::Application.column_names.include?("scopes")
    end

    def generate_secret
      if secret.blank?
        self.secret = UniqueToken.generate
      end
    end
  end
end
