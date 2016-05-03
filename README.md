
# OmniAuth Intercom

Intercom OAuth2 Strategy for OmniAuth.

Supports the OAuth 2.0 server-side and client-side flows. Read the [Intercom OAuth docs](https://developers.intercom.io/reference#oauth) for more details:

## Installing

Add to your `Gemfile`:

```ruby
gem 'omniauth-intercom'
```

Then `bundle install`.

## Usage

`OmniAuth::Strategies::Intercom` is simply a Rack middleware. Read the OmniAuth docs for detailed instructions: https://github.com/intridea/omniauth.

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :intercom, ENV['INTERCOM_KEY'], ENV['INTERCOM_SECRET']
end
```
To start the authentication process with Intercom you simply need to access `/auth/intercom` route.

**Important** You need the `read_admins` permissions to use this middleware.   
**Important** Your `redirect_url` should be `/auth/intercom/callback`

## Auth Hash

Here's an example *Auth Hash* available in `request.env['omniauth.auth']`:

```ruby
{
  :provider => 'intercom',
  :uid => '342324',
  :info => {
    :email => 'kevin.antoine@intercom.io',
    :name => 'Kevin Antoine'
  },
  :credentials => {
    :token => 'dG9rOmNdrWt0ZjtgzzE0MDdfNGM5YVe4MzsmXzFmOGd2MDhiMfJmYTrxOtA=', # OAuth 2.0 access_token, which you may wish to store
    :expires => false
  },
  :extra => {
    :raw_info => {
      :name => 'Kevin Antoine',
      :email => 'kevin.antoine@intercom.io',
      :type => 'admin',
      :id => '342324',
      :app => {
        :id_code => 'abc123', # Company app_id
        :type: 'app'
      }
      :avatar => {
        :image_url => "https://static.intercomassets.com/avatars/343616/square_128/me.jpg?1454165491"
      }
    }
  }
}
```
