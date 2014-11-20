require 'spec_helper'

describe Contactually::API do

  describe 'missing configuration' do
    before(:all) { Contactually.configure { |c| c.api_key = nil } }
    specify do
      expect{ subject }.to raise_error Contactually::ConfigMissingApiKeyError
    end

    it 'allows to supply api key via initialize' do
      expect{ described_class.new('asdf') }.not_to raise_error
    end

    it 'sets api_key from parameters' do
      expect(described_class.new('asdf').instance_variable_get(:@api_key)).to eq 'asdf'
    end
  end

  describe 'valid configuration' do
    before(:all) { Contactually.configure { |c| c.api_key = 'VALID_API_KEY' } }

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
      it 'redirects get request to get' do
        allow(subject).to receive(:get).and_return(Struct.new(:status, :body).new(200, {}))
        subject.call('bla', :get, {})
        expect(subject).to have_received(:get).with('bla', {})
      end

      it 'redirects post request to post' do
        allow(subject).to receive(:post).and_return(Struct.new(:status, :body).new(200, {}))
        subject.call('bla', :post, {})
        expect(subject).to have_received(:post).with('bla', {})
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

    describe '#accounts' do
      specify do
        expect(subject.accounts).to be_kind_of Contactually::Accounts
      end
    end

    describe '#contact_groupings' do
      specify do
        expect(subject.contact_groupings).to be_kind_of Contactually::ContactGroupings
      end
    end

    describe '#contacts' do
      specify do
        expect(subject.contacts).to be_kind_of Contactually::Contacts
      end
    end

    describe '#contents' do
      specify do
        expect(subject.contents).to be_kind_of Contactually::Contents
      end
    end

    describe '#groupings' do
      specify do
        expect(subject.groupings).to be_kind_of Contactually::Groupings
      end
    end

    describe '#notes' do
      specify do
        expect(subject.notes).to be_kind_of Contactually::Notes
      end
    end

    describe '#tasks' do
      specify do
        expect(subject.tasks).to be_kind_of Contactually::Tasks
      end
    end

    describe 'endpoints' do
      %w{ accounts contact_groupings contacts contents groupings notes tasks }.each do |endpoint|
        specify { expect(subject.respond_to?(endpoint)).to eq true }
      end
    end

    describe '#get' do
      it 'parses from json response' do
        allow(subject.connection).to receive(:get).
          with('https://www.contactually.com/api/v1/url', { foo: :bar, api_key: 'VALID_API_KEY' }).
          and_return(Struct.new(:status, :body).new(200, "{ \"foo\": \"bar\" }"))
        expect(subject.call('url', :get, { foo: :bar })).to be_kind_of Hash
      end
    end

    describe '#post' do
      it 'parses from json response' do
        allow(subject.connection).to receive(:post).and_return(Struct.new(:status, :body).new(200, "{ \"foo\": \"bar\" }"))
        expect(subject.call('url', :post, { foo: :bar })).to be_kind_of Hash
      end
    end
  end
end
