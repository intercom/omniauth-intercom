
require 'spec_helper'

describe OmniAuth::Strategies::Intercom do

  let(:access_token) { stub('AccessToken', :options => {})}
  let(:token) { 'some-token' }
  let(:parsed_response) { JSON.parse({ :email => 'kevin.antoine@intercom.io', :name => 'Kevin Antoine', :avatar => { :image_url => 'https://static.intercomassets.com/avatars/343616/square_128/me.jpg?1454165491' } }.to_json) }
  let(:response) { stub('Response', :parsed => parsed_response) }
  let(:client) { stub('Client') }
  let(:connection) { stub('Connection') }
  let(:headers) { {} }
  let(:options) { {} }

  subject do
    OmniAuth::Strategies::Intercom.new({})
  end

  before do
    OmniAuth.config.full_host = 'http://test.host'
    allow(subject).to receive(:access_token).and_return access_token
    allow(access_token).to receive(:client).and_return client
    allow(access_token).to receive(:options).and_return options
    allow(access_token).to receive(:token).and_return token
    allow(access_token).to receive(:get).with('/me').and_return response
    allow(client).to receive(:connection).and_return connection
    allow(connection).to receive(:headers).and_return headers
    allow(connection).to receive(:basic_auth).and_return "Bearer #{token}"
    allow(response).to receive(:parsed).and_return parsed_response
  end

  context '#raw_info' do
    it 'request "me"' do
      expect(access_token).to receive(:get).with('/me').and_return response

      subject.raw_info
    end

    it 'returns the raw_info' do
      expect(subject.raw_info).to eq parsed_response
    end
  end

  context '#info' do
    it 'should have the name' do
      expect(subject.info[:name]).to eq('Kevin Antoine')
    end

    it 'should have the email' do
      expect(subject.info[:email]).to eq('kevin.antoine@intercom.io')
    end

    it 'should have the image' do
      expect(subject.info[:image]).to eq('https://static.intercomassets.com/avatars/343616/square_128/me.jpg?1454165491')
    end

    context 'when the avatar is not available' do
      before do
        parsed_response.delete('avatar')
      end

      it 'should have the image' do
        expect(subject.info[:image]).to eq(nil)
      end
    end
  end

  context 'when using signup' do
    let(:params) { { 'signup' => '1' } }

    before do
      allow(subject.request).to receive(:params).and_return params
    end

    context 'when the request phase starts' do
      before do
        subject.request_phase rescue nil
      end

      it 'changes the authorize_url to signup' do
        expect(subject.options.client_options[:authorize_url]).to eq('https://app.intercom.io/oauth/signup')
      end
    end
  end
end
