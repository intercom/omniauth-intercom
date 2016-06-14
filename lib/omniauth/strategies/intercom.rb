require 'omniauth-oauth2'
module OmniAuth
  module Strategies
    class Intercom < OmniAuth::Strategies::OAuth2
      option :name, 'intercom'

      option :client_options, {
        :site => 'https://api.intercom.io',
        :authorize_url => 'https://app.intercom.io/oauth',
        :token_url => 'https://api.intercom.io/auth/eagle/token'
      }

      uid { raw_info['id'] }

      info do
        {
          :name => raw_info['name'],
          :email => raw_info['email'],
        }.tap do |info|
          avatar = raw_info['avatar'] && raw_info['avatar']['image_url']

          info[:image] = avatar if avatar
        end
      end

      extra do
        {
          :raw_info => raw_info
        }
      end

      def raw_info
        accept_headers
        access_token.options[:mode] = :body
        @raw_info ||= access_token.get('/me').parsed
      end

      def request_phase
        options.client_options[:authorize_url] += '/signup' if request.params.fetch('signup', false)

        super
      end

      protected

      def accept_headers
        access_token.client.connection.headers['Authorization'] = access_token.client.connection.basic_auth(access_token.token, '')
        access_token.client.connection.headers['Accept'] = "application/vnd.intercom.3+json"
      end

    end
  end
end
