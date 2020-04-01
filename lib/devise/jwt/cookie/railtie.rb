require 'rails/railtie'

module Devise
  module JWT
    module Cookie
      class Railtie < Rails::Railtie
        initializer 'devise-jwt-cookie-middleware' do |app|
          app.middleware.insert_before Warden::JWTAuth::Middleware, Devise::JWT::Cookie::Middleware
        end
      end
    end
  end
end