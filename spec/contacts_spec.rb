require 'spec_helper'

describe Contactually::Contacts do

  before(:all) do
    Contactually.api_key = 'VALID_API_KEY'
    @master = Contactually::API.new
  end

  subject { described_class.new @master }
  describe '#initialize' do
    specify do
      expect(subject).to be_kind_of Contactually::Contacts
    end

    specify do
      expect(subject.instance_variable_get(:@master)).to be_kind_of Contactually::API
    end
  end

  describe '#create' do
    it 'throws an error if contact hash is missing' do
      expect{ subject.create }.to raise_error Contactually::MissingParameterError
    end

    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contacts.json', :post, { contact: { foo: :bar }})
      subject.create({ contact: { foo: :bar }})
    end
  end

  describe '#delete' do
    it 'throws an error if contact id is missing' do
      expect{ subject.delete }.to raise_error Contactually::MissingParameterError
    end

    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contacts/1.json', :delete, {})
      subject.delete({ id: 1 })
    end
  end

  describe '#destroy_multiple' do
    it 'throws an error if contact ids are missing' do
      expect{ subject.destroy_multiple}.to raise_error Contactually::MissingParameterError
    end

    it 'throws an error if contact ids is no array' do
      expect{ subject.destroy_multiple({ ids: 1 }) }.to raise_error Contactually::MissingParameterError
    end

    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contacts.json', :delete, { ids: [ 1, 2, 3 ]})
      subject.destroy_multiple({ ids: [ 1, 2, 3 ]})
    end
  end

  describe '#show' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contacts/1.json', :get, { foo: :bar }).and_return({ id: 1 })
      subject.show({ id: 1, foo: :bar })
    end

    it 'returns a contact' do
      json = File.read(File.join(File.dirname(__FILE__),"fixtures/contact.json"))
      allow(@master).to receive(:call).with('contacts/1.json', :get, { foo: :bar }).and_return(JSON.load(json))
      expect(subject.show({ id: 1, foo: :bar })).to be_kind_of Contactually::Contact
    end
  end

  describe '#tags' do
    it 'throws an error if contact id is missing' do
      expect{ subject.tags({ tags: [ 'lol' ]}) }.to raise_error Contactually::MissingParameterError
    end

    it 'throws an error if tags are missing' do
      expect{ subject.tags({ id: 1 }) }.to raise_error Contactually::MissingParameterError
    end

    it 'throws an error if tags is no array' do
      expect{ subject.tags({ id: 1, tags: 'lol' }) }.to raise_error Contactually::MissingParameterError
    end

    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contacts/1/tags.json', :post, { tags: [ 'lol' ] })
      subject.tags({ id: 1, tags: [ 'lol' ]})
    end
  end

  describe '#update' do
    it 'throws an error if contact hash is missing' do
      expect{ subject.update({ id: 1 }) }.to raise_error Contactually::MissingParameterError
    end

    it 'throws an error if contact id is missing' do
      expect{ subject.update({ contact: { foo: :bar } }) }.to raise_error Contactually::MissingParameterError
    end

    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contacts/1.json', :put, { contact: { foo: :bar }})
      subject.update({ id: 1, contact: { foo: :bar } })
    end
  end

  describe '#index' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contacts.json', :get, { foo: :bar }).and_return({ 'contacts' => [] })
      subject.index({ foo: :bar })
    end

    it 'returns contacts from json response' do
      json = File.read(File.join(File.dirname(__FILE__),"fixtures/contacts_index.json"))
      allow(@master).to receive(:call).with('contacts.json', :get, {}).and_return(JSON.load(json))
      expect(subject.index({})).to be_kind_of Array
      expect(subject.index({})[0]).to be_kind_of Contactually::Contact
    end
  end

  describe '#search' do
    it 'throws an Error if search term is missing' do
      expect{ subject.search }.to raise_error Contactually::MissingParameterError
    end

    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contacts/search.json', :get, { term: :foo_bar }).and_return({ 'contacts' => [] })
      subject.search({ term: :foo_bar})
    end

    it 'returns contacts from json response' do
      json = File.read(File.join(File.dirname(__FILE__),"fixtures/contacts_index.json"))
      allow(@master).to receive(:call).with('contacts/search.json', :get, { term: :foo_bar }).and_return(JSON.load(json))
      expect(subject.search({ term: :foo_bar })).to be_kind_of Array
      expect(subject.search({ term: :foo_bar })[0]).to be_kind_of Contactually::Contact
    end
  end

  describe '#params_without_id' do
    specify do
      expect(subject.send(:params_without_id, { id: 1, foo: :bar })).to eq({ foo: :bar })
    end
  end

end
