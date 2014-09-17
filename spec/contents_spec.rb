require 'spec_helper'

describe Contactually::Contents do

  let(:content_json) { File.read(File.join(File.dirname(__FILE__),"fixtures/content.json")) }
  let(:contents_index_json) { File.read(File.join(File.dirname(__FILE__),"fixtures/contents_index.json")) }

  before(:all) do
    Contactually.configure { |c| c.api_key = 'VALID_API_KEY' }
    @master = Contactually::API.new
  end

  subject { described_class.new @master }
  describe '#initialize' do
    specify do
      expect(subject).to be_kind_of Contactually::Contents
    end

    specify do
      expect(subject.instance_variable_get(:@master)).to be_kind_of Contactually::API
    end
  end

  describe '#create' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contents.json', :post, { content: { foo: :bar }}).and_return(JSON.load(content_json))
      subject.create({ content: { foo: :bar }})
      expect(@master).to have_received(:call)
    end

    it 'returns a content' do
      allow(@master).to receive(:call).with('contents.json', :post, { content: { foo: :bar }}).and_return(JSON.load(content_json))
      expect(subject.create({ content: { foo: :bar }})).to be_kind_of Contactually::Content
    end
  end

  describe '#index' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contents.json', :get, { foo: :bar }).and_return({ 'contents' => [] })
      subject.index({ foo: :bar })
      expect(@master).to have_received(:call)
    end

    it 'returns contents from json response' do
      allow(@master).to receive(:call).with('contents.json', :get, {}).and_return(JSON.load(contents_index_json))
      expect(subject.index({})).to be_kind_of Array
      expect(subject.index({})[0]).to be_kind_of Contactually::Content
    end
  end

  describe '#destroy' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contents/115.json', :delete, { foo: :bar }).and_return({ 'success' => true })
      subject.destroy(115, { foo: :bar })
      expect(@master).to have_received(:call)
    end
  end

  describe '#show' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contents/1.json', :get, { foo: :bar }).and_return({ id: 1 })
      subject.show(1, { foo: :bar })
      expect(@master).to have_received(:call)
    end

    it 'returns a contact' do
      allow(@master).to receive(:call).with('contents/1.json', :get, { foo: :bar }).and_return(JSON.load(content_json))
      expect(subject.show(1, { foo: :bar })).to be_kind_of Contactually::Content
    end
  end

  describe '#update' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contents/1.json', :put, { content: { foo: :bar }})
      subject.update(1, { content: { foo: :bar } })
      expect(@master).to have_received(:call)
    end
  end

end
