require 'omniauth-oauth2'
require 'base64'

module OmniAuth
  module Strategies
    class Intercom < OmniAuth::Strategies::OAuth2
      option :name, 'intercom'

      option :client_options, {
        :site => 'https://api.intercom.io',
        :authorize_url => 'https://app.intercom.com/oauth',
        :token_url => 'https://api.intercom.io/auth/eagle/token'
      }

      option :verify_email, true

      uid { raw_info['id'] }

      info do
        {
          :name => raw_info['name'],
          :email => raw_info['email'],
        }.tap do |info|
          avatar = raw_info['avatar'] && raw_info['avatar']['image_url']
          info[:image] = avatar if avatar

          workspace_id = raw_info['app'] && raw_info['app']['id_code']
          info[:workspace_id] = workspace_id if workspace_id
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
        @raw_info ||= begin
          parsed = access_token.get('/me').parsed
          if options.verify_email && parsed['email_verified'] != true
            return {}
          end
         parsed
        end
      end

      def request_phase
        prepopulate_signup_fields_form if request.params.fetch('signup', false)
        super
      end

      protected

      def accept_headers
        access_token.client.connection.headers['Authorization'] = "Basic #{basic_auth_credentials}"
        access_token.client.connection.headers['Accept'] = "application/vnd.intercom.3+json"
        access_token.client.connection.headers['User-Agent'] = "omniauth-intercom/#{::OmniAuth::Intercom::VERSION}"
      end

      def basic_auth_credentials
        Base64.encode64("#{access_token.token}:").delete("\n")
      end

      def prepopulate_signup_fields_form
        options.client_options[:authorize_url] += '/signup'
        signup_hash = signup_fields_hash
        options.client_options[:authorize_url] += '?' + signup_hash.map{|k,v| [CGI.escape(k.to_s), "=", CGI.escape(v.to_s)]}.map(&:join).join("&") unless signup_hash.empty?
      end

      def signup_fields_hash
        hash = {}
        ['name', 'email', 'app_name'].each do |field_name|
          hash[field_name] = request.params.fetch(field_name) if request.params.fetch(field_name, false)
        end
        return hash
      end

    end
  end
end
