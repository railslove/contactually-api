require 'spec_helper'

describe Contactually::API do

  describe 'missing configuration' do
    specify do
      expect{ subject }.to raise_error Contactually::ConfigMissingApiKeyError
    end
  end

  describe 'valid configuration' do
    before(:all) { Contactually.api_key = 'VALID_API_KEY' }

    describe '#initialize' do
      it 'initializes correctly' do
        expect{ subject }.not_to raise_error
        expect(subject).to be_kind_of Contactually::API
      end

      it 'sets instance variables' do
        expect(subject.instance_variable_get(:@api_key)).to eq 'VALID_API_KEY'
        expect(subject.instance_variable_get(:@base_url)).to eq Contactually.contactually_url
      end
    end

    describe '#call' do
      it 'redirects get request to get_call' do
        allow(subject).to receive(:get_call)
        subject.call('bla', :get, {})
        expect(subject).to have_received(:get_call).with('bla', {})
      end

      it 'redirects post request to post_call' do
        allow(subject).to receive(:post_call)
        subject.call('bla', :post, {})
        expect(subject).to have_received(:post_call).with('bla', {})
      end
    end

    describe '#call_params' do
      specify do
        expect(subject.send(:call_params, { foo: :bar })).to eql({ api_key: 'VALID_API_KEY', foo: :bar })
      end
    end

    describe '#base_url' do
      specify do
        expect(subject.send(:base_url, 'foo/bar')).to eql("#{Contactually.contactually_url}foo/bar")
      end
    end

    describe '#contacts' do
      specify do
        expect(subject.contacts).to be_kind_of Contactually::Contacts
      end
    end

    describe '#notes' do
      specify do
        expect(subject.notes).to be_kind_of Contactually::Notes
      end
    end

    describe '#groupings' do
      specify do
        expect(subject.groupings).to be_kind_of Contactually::Groupings
      end
    end

    describe '#get_call' do
      it 'parses from json response' do
        allow(Faraday).to receive(:get).
          with('https://www.contactually.com/api/v1/url', { foo: :bar, api_key: 'VALID_API_KEY' }).
          and_return(Struct.new(:body).new("{ \"foo\": \"bar\" }"))
        expect(subject.call('url', :get, { foo: :bar })).to be_kind_of Hash
      end
    end

    describe '#post_call' do
      it 'parses from json response' do
        allow(Faraday).to receive(:post).and_return(Struct.new(:body).new("{ \"foo\": \"bar\" }"))
        expect(subject.call('url', :post, { foo: :bar })).to be_kind_of Hash
      end
    end

    describe '#handle_response' do
      it 'should parse json body' do
        response = Struct.new(:status, :body).new(200, 'Body')
        allow(JSON).to receive(:load).with('Body')
        subject.send(:handle_response, response)
        expect(JSON).to have_received(:load)
      end

      it 'should throw error on 406' do
        response = Struct.new(:status, :body).new(406, 'Error')
        allow(JSON).to receive(:load).with('Error')
        expect{ subject.send(:handle_response, response) }.to raise_error Contactually::APINotAcceptableError
      end

      it 'should throw error on everything else' do
        response = Struct.new(:status, :body).new(500, 'Error')
        allow(JSON).to receive(:load).with('Error')
        expect{ subject.send(:handle_response, response) }.to raise_error Contactually::Error
      end


    end
  end
end
