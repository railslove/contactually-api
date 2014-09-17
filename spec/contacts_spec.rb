require 'spec_helper'

describe Contactually::Contacts do

  let(:contact_json) { File.read(File.join(File.dirname(__FILE__),"fixtures/contact.json")) }
  let(:contacts_index_json) { File.read(File.join(File.dirname(__FILE__),"fixtures/contacts_index.json")) }

  before(:all) do
    Contactually.configure { |c| c.api_key = 'VALID_API_KEY' }
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
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contacts.json', :post, { contact: { foo: :bar }}).and_return(JSON.load(contact_json))
      subject.create({ contact: { foo: :bar }})
      expect(@master).to have_received(:call)
    end

    it 'returns a contact' do
      allow(@master).to receive(:call).with('contacts.json', :post, { contact: { foo: :bar }}).and_return(JSON.load(contact_json))
      expect(subject.create({ contact: { foo: :bar } })).to be_kind_of Contactually::Contact
    end
  end

  describe '#destroy' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contacts/1.json', :delete, {})
      subject.destroy(1)
      expect(@master).to have_received(:call)
    end
  end

  describe '#destroy_multiple' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contacts.json', :delete, { ids: [ 1, 2, 3 ]})
      subject.destroy_multiple({ ids: [ 1, 2, 3 ]})
      expect(@master).to have_received(:call)
    end
  end

  describe '#show' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contacts/1.json', :get, { foo: :bar }).and_return({ id: 1 })
      subject.show(1, { foo: :bar })
      expect(@master).to have_received(:call)
    end

    it 'returns a contact' do
      allow(@master).to receive(:call).with('contacts/1.json', :get, { foo: :bar }).and_return(JSON.load(contact_json))
      expect(subject.show(1, { foo: :bar })).to be_kind_of Contactually::Contact
    end
  end

  describe '#tags' do
    it 'calls the api with correct params - Array' do
      allow(@master).to receive(:call).with('contacts/1/tags.json', :post, { tags: 'lol, haha' })
      subject.tags(1, { tags: [ 'lol', 'haha' ]})
      expect(@master).to have_received(:call)
    end

    it 'calls the api with correct params - String' do
      allow(@master).to receive(:call).with('contacts/1/tags.json', :post, { tags: 'lol, haha' })
      subject.tags(1, { tags: 'lol, haha' })
      expect(@master).to have_received(:call)
    end
  end

  describe '#update' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contacts/1.json', :put, { contact: { foo: :bar }})
      subject.update(1, { contact: { foo: :bar } })
      expect(@master).to have_received(:call)
    end
  end

  describe '#index' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contacts.json', :get, { foo: :bar }).and_return({ 'contacts' => [] })
      subject.index({ foo: :bar })
      expect(@master).to have_received(:call)
    end

    it 'returns contacts from json response' do
      allow(@master).to receive(:call).with('contacts.json', :get, {}).and_return(JSON.load(contacts_index_json))
      expect(subject.index({})).to be_kind_of Array
      expect(subject.index({})[0]).to be_kind_of Contactually::Contact
    end
  end

  describe '#search' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contacts/search.json', :get, { term: :foo_bar }).and_return({ 'contacts' => [] })
      subject.search({ term: :foo_bar})
      expect(@master).to have_received(:call)
    end

    it 'returns contacts from json response' do
      allow(@master).to receive(:call).with('contacts/search.json', :get, { term: :foo_bar }).and_return(JSON.load(contacts_index_json))
      expect(subject.search({ term: :foo_bar })).to be_kind_of Array
      expect(subject.search({ term: :foo_bar })[0]).to be_kind_of Contactually::Contact
    end
  end
end
