
require 'spec_helper'

describe OmniAuth::Strategies::Intercom do

  let(:access_token) { stub('AccessToken', :options => {})}
  let(:token) { 'some-token' }
  let(:parsed_response) { {:email => 'kevin.antoine@intercom.io', :name => 'Kevin Antoine'} }
  let(:response) { stub('Response', :parsed => parsed_response) }
  let(:client) { stub('Client') }
  let(:connection) { stub('Connection') }
  let(:headers) { {} }
  let(:options) { {} }

  subject do
    OmniAuth::Strategies::Intercom.new({})
  end

  before(:each) do
    allow(subject).to receive(:access_token).and_return access_token
    allow(access_token).to receive(:client).and_return client
    allow(client).to receive(:connection).and_return connection
    allow(connection).to receive(:headers).and_return headers
    allow(connection).to receive(:basic_auth).and_return "Bearer #{token}"
    allow(access_token).to receive(:options).and_return options
    allow(access_token).to receive(:token).and_return token
    allow(response).to receive(:parsed).and_return parsed_response
  end

  context "#raw_info" do
    it "should return raw_info" do
      expect(access_token).to receive(:get).with('/me').and_return response
      expect(subject.raw_info).to eq parsed_response
    end
  end
  context "#signup" do
    let(:params) { { 'signup' => '1' } }
    before do
      allow(subject).to receive(:request).and_return Object.new()
      allow(subject.request).to receive(:params).and_return params
    end
    it "should change authorize_url to signup" do
      subject.send(:authorize_url)
      expect(subject.options.client_options[:authorize_url]).to eq 'https://app.intercom.io/oauth/signup'
    end
  end
end
