module Doorkeeper
  class Application
    include DoorkeeperDynamodb::Compatible
    include OAuth::Helpers
    include Models::Expirable
    include Models::Revocable
    include Models::Accessible
    include Models::Scopes

    include Dynamoid::Document
    table name: :oauth_applications
    has_many :grants, class_name: 'Doorkeeper::AccessGrant', :inverse_of => :application
    has_many :tokens, class_name: 'Doorkeeper::AccessToken', :inverse_of => :application
    after_destroy :delete_assoications

    field :name,         :string
    field :secret,       :string
    field :redirect_uri, :string
    field :scopes,       :string
    validates :name, :secret, presence: true
    validates :redirect_uri, presence: true

    before_validation :generate_secret, on: :create

    class << self
      def authorized_for(resource_owner)
        ids = AccessToken.where(
          resource_owner_id: resource_owner.id,
          revoked_at: nil
        ).all
        authorized = ids.inject([]) do |array, id|
          array << find(id)
          array
        end
      end

      def by_uid_and_secret(uid, secret)
        where(id: uid, secret: secret).first
      end

      def by_uid(uid)
        find(id: uid)
      end
    end

    def validate_owner?
      false
    end

    private

    def delete_assoications
      AccessGrant.find_all(grants_ids).destroy_all if grants_ids
      AccessToken.find_all(tokens_ids).destroy_all if tokens_ids
    end

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
