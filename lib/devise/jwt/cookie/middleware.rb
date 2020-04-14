module Devise
  module JWT
    module Cookie
      class Middleware
        ENV_KEY = 'warden-jwt_auth.token'

        attr_reader :app, :config

        def initialize(app)
          @app = app
          @config = Warden::JWTAuth.config
        end

        def call(env)
          status, headers, response = app.call(env)
          if headers['Authorization'] && env[ENV_KEY]
            name, cookie = CookieHelper.new.build(env[ENV_KEY])
            Rack::Utils.set_cookie_header!(headers, name, cookie)
          elsif token_should_be_revoked?(env)
            name, cookie = CookieHelper.new.build(nil)
            Rack::Utils.set_cookie_header!(headers, name, cookie)
          end
          [status, headers, response]
        end

        def token_should_be_revoked?(env)
          path_info = env['PATH_INFO'] || ''
          method = env['REQUEST_METHOD']
          revocation_requests = config.revocation_requests
          revocation_requests.each do |tuple|
            revocation_method, revocation_path = tuple
            return true if path_info.match(revocation_path) &&
                           method == revocation_method
          end
          false
        end
      end
    end
  end
end