module Devise
  module JWT
    module Cookie
      class Middleware
        ENV_KEY = 'warden-jwt_auth.token'

        def initialize(app)
          @app = app
        end

        def call(env)
          status, headers, response = @app.call(env)
          if headers['Authorization'] && env[ENV_KEY]
            name, cookie = CookieHelper.new.build(env[ENV_KEY])
            Rack::Utils.set_cookie_header!(headers, name, cookie)
          end
          [status, headers, response]
        end
      end
    end
  end
end