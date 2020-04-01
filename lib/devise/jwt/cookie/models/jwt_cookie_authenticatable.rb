require 'active_support/concern'

module Devise
  module Models
    module JwtCookieAuthenticatable
      extend ActiveSupport::Concern

      included do
        def self.find_for_jwt_authentication(sub)
          find_by(primary_key => sub)
        end
      end

      def jwt_subject
        id
      end
    end
  end
end
