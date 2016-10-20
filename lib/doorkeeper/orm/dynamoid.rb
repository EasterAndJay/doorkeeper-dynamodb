module Doorkeeper
  module Orm
    module Dynamoid
      def self.initialize_models!
        require 'doorkeeper/orm/dynamoid/access_grant'
        require 'doorkeeper/orm/dynamoid/access_token'
        require 'doorkeeper/orm/dynamoid/application'
      end

      def self.initialize_application_owner!
        require 'doorkeeper/models/concerns/ownership'

        Doorkeeper::Application.send :include, Doorkeeper::Models::Ownership
      end

      def self.check_requirements!(_config); end
    end
  end
end
