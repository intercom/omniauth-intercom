require 'omniauth-oauth2'
require 'uri'

module OmniAuth
  module Strategies
    class Intercom < OmniAuth::Strategies::OAuth2
      option :name, 'intercom'

      option :client_options, {
        site:          'https://api.intercom.io',
        token_url:     'https://api.intercom.io/auth/eagle/token',
        authorize_url: 'https://app.intercom.com/oauth'
      }

      option :verify_email, true

      uid { raw_info['id'] }

      info do
        next {} if raw_info.empty?

        avatar = raw_info.fetch('avatar', {})
        app    = raw_info.fetch('app', {})

        {
          name:      raw_info['name'],
          email:     raw_info['email'],
          verfied:   raw_info['email_verified'],
          image:     avatar['image_url'],
          time_zone: app['timezone']
        }
      end

      extra do
        {
          raw_info: raw_info
        }
      end

      def raw_info
        headers = { 'Accept' => 'application/vnd.intercom.3+json' }

        @raw_info ||= access_token.get('/me', headers: headers).parsed.tap do |hash|
          if options.verify_email && hash['email_verified'] != true
            hash.clear
          end
        end
      end

      def request_phase
        prepare_request_phase_for_signup
        super
      end

    protected

      def prepare_request_phase_for_signup
        return unless request.params['signup']
        options.client_options[:authorize_url] += '/signup'

        signup_params = build_signup_params(request.params)
        return if signup_params.empty?

        options.client_options[:authorize_url] += "?#{URI.encode_www_form(signup_params)}"
      end

      def build_signup_params(params)
        %w[name email app_name].each_with_object({}) do |field_name, hash|
          hash.merge!(field_name => params[field_name]) if params[field_name]
        end
      end
    end
  end
end
