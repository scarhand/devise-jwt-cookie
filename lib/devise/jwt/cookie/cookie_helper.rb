module Devise
  module JWT
    module Cookie
      class CookieHelper
        include Cookie::Import['name', 'domain', 'secure']

        def build(token)
          res = {
            value: token,
            path: '/',
            httponly: true,
            secure: secure
          }
          res[:domain] = domain if domain.present?
          [name, res]
        end

        def read_from(cookies)
          cookies[name]
        end
      end
    end
  end
end