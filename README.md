# Devise::JWT::Cookie

`devise-jwt-cookie` is a [devise](https://github.com/plataformatec/devise) extension based on [devise-jwt](https://github.com/waiting-for-dev/devise-jwt). It should be used alongside `devise-jwt`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'devise-jwt', '~> 0.5.9'
```

And then execute:

    $ bundle

## Usage

First you need to setup up and configure devise and devise-jwt. This gem hooks into devise-jwt to add an httpOnly cookie with the JWT.

### Model configuration

You have to update the user model to be able to use the cookie method. For example:

```ruby
class User < ApplicationRecord
  devise :database_authenticatable,
         :jwt_cookie_authenticatable,
         :jwt_authenticatable, jwt_revocation_strategy: Blacklist
end
```

### Configuration reference

This library can be configured by calling `jwt_cookie` on the devise config object:

```ruby
Devise.setup do |config|
  config.jwt do |jwt|
    # config for devise-jwt goes here
  end
  config.jwt_cookie do |jwt_cookie|
    # ...
  end
end
```

#### name

The name of the cookie. Defaults to `access_token`.

#### domain

The domain the cookie should be issued to. Will be omitted if not set.

#### secure

If a secure cookie should be set, this means the cookie must be sent over a secure connection. Defaults to true.

