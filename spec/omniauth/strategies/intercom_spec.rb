require 'spec_helper'

describe OmniAuth::Strategies::Intercom do
  let(:access_token) { double('AccessToken', options: {}) }
  let(:access_token_headers) { {headers: {"Accept" => "application/vnd.intercom.3+json"}} }
  let(:token) { 'some-token' }
  let(:client) { double('Client') }
  let(:connection) { double('Connection') }
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

    allow(client).to receive(:connection).and_return connection
    allow(connection).to receive(:headers).and_return headers
    allow(connection).to receive(:basic_auth).and_return "Bearer #{token}"
  end

  context 'with verified email' do
    let(:parsed_response) { JSON.parse({email: 'kevin.antoine@intercom.io', name: 'Kevin Antoine', avatar: {image_url: 'https://static.intercomassets.com/avatars/343616/square_128/me.jpg?1454165491'}, email_verified: true}.to_json) }
    let(:response) { double('Response', :parsed => parsed_response) }

    before do
      allow(access_token).to receive(:get).with('/me', access_token_headers).and_return response
      allow(response).to receive(:parsed).and_return parsed_response
    end

    context '#raw_info' do
      it 'request "me"' do
        expect(access_token).to receive(:get).with('/me', access_token_headers).and_return response

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

      before do
        allow(subject.request).to receive(:params).and_return params
      end

      context 'when the request phase starts with signup params provided' do
        let(:params) { {'signup' => '1'} }

        before do
          subject.request_phase rescue nil
        end

        it 'changes the authorize_url to signup url' do
          expect(subject.options.client_options[:authorize_url]).to eq('https://app.intercom.com/oauth/signup')
        end
      end

      context 'when the request phase starts with signup params and fields values provided' do
        let(:params) { {'signup' => '1', 'name' => 'Test Testovich', 'email' => 'test@testovichmail.com', 'app_name' => 'Testovich App'} }

        before do
          subject.request_phase rescue nil
        end

        it 'prepopulate oauth form with those values' do
          expect(subject.options.client_options[:authorize_url]).to eq('https://app.intercom.com/oauth/signup?name=Test+Testovich&email=test%40testovichmail.com&app_name=Testovich+App')
        end
      end
    end
  end

  context 'with unverified email' do
    let(:parsed_response) { JSON.parse({email: 'kevin.antoine@intercom.io', name: 'Kevin Antoine', avatar: {image_url: 'https://static.intercomassets.com/avatars/343616/square_128/me.jpg?1454165491'}, email_verified: false}.to_json) }
    let(:response) { double('Response', :parsed => parsed_response) }

    before do
      allow(access_token).to receive(:get).with('/me', access_token_headers).and_return response
      allow(response).to receive(:parsed).and_return parsed_response
    end

    context 'with verify_email option' do
      context '#raw_info' do
        it 'returns blank raw_info' do
          expect(subject.raw_info).to eq({})
        end
      end

      context '#info' do
        it 'should not have the name' do
          expect(subject.info[:name]).to eq(nil)
        end

        it 'should not have the email' do
          expect(subject.info[:email]).to eq(nil)
        end

        it 'should not have the image' do
          expect(subject.info[:image]).to eq(nil)
        end
      end
    end

    context 'with verify_email option set to false' do

      before do
        subject.options.verify_email = false
      end

      context '#raw_info' do
        it 'returns blank raw_info' do
          expect(subject.raw_info).to eq(parsed_response)
        end
      end

      context '#info' do
        it 'should not have the name' do
          expect(subject.info[:name]).to eq('Kevin Antoine')
        end

        it 'should not have the email' do
          expect(subject.info[:email]).to eq('kevin.antoine@intercom.io')
        end

        it 'should not have the image' do
          expect(subject.info[:image]).to eq('https://static.intercomassets.com/avatars/343616/square_128/me.jpg?1454165491')
        end
      end
    end

  end
end
