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
          token_should_be_revoked = token_should_be_revoked?(env)
          if token_should_be_revoked
            # add the Authorization header, devise-jwt needs this to revoke tokens
            # we need to make sure this is done before the other middleware is run
            request = ActionDispatch::Request.new(env)
            env['HTTP_AUTHORIZATION'] = "Bearer #{CookieHelper.new.read_from(request.cookies)}"
          end

          status, headers, response = app.call(env)
          if headers['Authorization'] && env[ENV_KEY]
            name, cookie = CookieHelper.new.build(env[ENV_KEY])
            Rack::Utils.set_cookie_header!(headers, name, cookie)
          elsif token_should_be_revoked
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