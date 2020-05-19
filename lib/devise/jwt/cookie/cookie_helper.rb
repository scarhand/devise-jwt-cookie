module Devise
  module JWT
    module Cookie
      class CookieHelper
        include Cookie::Import['name', 'domain', 'secure', 'same_site']

        def build(token)
          validate_options!
          if token.nil?
            remove_cookie
          else
            create_cookie(token)
          end
        end

        def read_from(cookies)
          cookies[name]
        end

        private

        def create_cookie(token)
          jwt = Warden::JWTAuth::TokenDecoder.new.call(token)
          res = {
            value: token,
            path: '/',
            httponly: true,
            secure: secure,
            expires: Time.at(jwt['exp'].to_i)
          }
          res[:domain] = domain if domain.present?
          res[:same_site] = same_site if same_site.present?
          [name, res]
        end

        def remove_cookie
          res = {
            value: nil,
            path: '/',
            httponly: true,
            secure: secure,
            max_age: '0',
            expires: Time.at(0)
          }
          res[:domain] = domain if domain.present?
          res[:same_site] = same_site if same_site.present?
          [name, res]
        end

        def validate_options!
          if same_site.present?
            raise 'If same_site is set to None, the cookie must be secure' if same_site == 'None' && !secure
            raise 'Invalid value for same_site, should be one of None, Lax or Strict' if !['None', 'Lax', 'Strict'].includes?(same_site)
          end
      end
    end
  end
end