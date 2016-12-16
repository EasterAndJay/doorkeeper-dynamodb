module DoorkeeperDynamodb
  module Compatible
    extend ActiveSupport::Concern

    module ClassMethods
      def transaction(_ = {}, &block)
        yield
      end

      def by_token(token)
        where(token: token).first
      end

      def by_refresh_token(refresh_token)
        where(refresh_token: refresh_token).first
      end

      def last_authorized_token_for(application_id, resource_owner_id)
        where({
          application_id: application_id,
          resource_owner_id: resource_owner_id,
          revoked_at: nil
        }).first
      end

      def last
        first
      end
    end

    def transaction(options = {}, &block)
      self.class.transaction(options, &block)
    end

    def lock!(_ = true)
      reload if persisted?
      self
    end
  end
end
