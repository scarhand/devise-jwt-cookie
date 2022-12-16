require 'warden'

module Devise
  module JWT
    module Cookie
      # Warden strategy to authenticate an user through a JWT token in
      # an http-only cookie
      class Strategy < Warden::Strategies::Base
        def valid?
          !token.nil?
        end

        def store?
          false
        end

        def authenticate!
          aud = Warden::JWTAuth::EnvHelper.aud_header(env)
          user = Warden::JWTAuth::UserDecoder.new.call(token, scope, aud)
          success!(user)
        rescue ::JWT::DecodeError => exception
          fail!(exception.message)
        end

        private

        def token
          @token ||= CookieHelper.new.read_from(cookies)
        end
      end
    end
  end
end

Warden::Strategies.add(:jwt_cookie, Devise::JWT::Cookie::Strategy)
