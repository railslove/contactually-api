require 'spec_helper'

describe Contactually::Notes do

  before(:all) do
    Contactually.api_key = 'VALID_API_KEY'
    @master = Contactually::API.new
  end

  subject { described_class.new @master }

  describe '#initialize' do
    specify do
      expect(subject).to be_kind_of Contactually::Notes
    end

    specify do
      expect(subject.instance_variable_get(:@master)).to be_kind_of Contactually::API
    end
  end

  describe '#index' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('notes.json', :get, { foo: :bar }).and_return({ 'notes' => [] })
      subject.index({ foo: :bar })
      expect(@master).to have_received(:call)
    end

    it 'returns notes from json response' do
      json = File.read(File.join(File.dirname(__FILE__),"fixtures/notes_index.json"))
      allow(@master).to receive(:call).with('notes.json', :get, {}).and_return(JSON.load(json))
      expect(subject.index({})).to be_kind_of Array
      expect(subject.index({})[0]).to be_kind_of Contactually::Note
    end
  end

  describe '#show' do
    it 'calls the api with correct params' do
      json = File.read(File.join(File.dirname(__FILE__),"fixtures/note.json"))
      allow(@master).to receive(:call).with('notes/1.json', :get, { foo: :bar }).and_return(JSON.load(json))
      subject.show({ id: 1, foo: :bar })
      expect(@master).to have_received(:call)
    end

    it 'returns a note' do
      json = File.read(File.join(File.dirname(__FILE__),"fixtures/note.json"))
      allow(@master).to receive(:call).with('notes/1.json', :get, { foo: :bar }).and_return(JSON.load(json))
      expect(subject.show({ id: 1, foo: :bar })).to be_kind_of Contactually::Note
    end
  end

  describe '#create' do
    specify do
      expect{ subject.create() }.to raise_error Contactually::MissingParameterError
    end

    it 'calls the api with correct params' do
      json = File.read(File.join(File.dirname(__FILE__),"fixtures/note.json"))
      allow(@master).to receive(:call).with('notes.json', :post, { note: { foo: :bar }}).and_return(JSON.load(json))
      subject.create({ note: { foo: :bar }})
      expect(@master).to have_received(:call)
    end

    it 'returns a note' do
      json = File.read(File.join(File.dirname(__FILE__),"fixtures/note.json"))
      allow(@master).to receive(:call).with('notes.json', :post, { note: { foo: :bar }}).and_return(JSON.load(json))
      expect(subject.create({ note: { foo: :bar }})).to be_kind_of Contactually::Note
    end
  end

  describe '#update' do
    it 'raises an error if id is missing' do
      expect{ subject.update() }.to raise_error Contactually::MissingParameterError
    end

    it 'raises an error if note hash is missing' do
      expect{ subject.update({ id: 1234 }) }.to raise_error Contactually::MissingParameterError
    end

    it 'calls the api with correct params' do
      json = File.read(File.join(File.dirname(__FILE__),"fixtures/note.json"))
      allow(@master).to receive(:call).with('notes/1.json', :put, { note: { foo: :bar }}).and_return(JSON.load(json))
      subject.update({ id: 1, note: { foo: :bar }})
      expect(@master).to have_received(:call)
    end

    it 'returns a note' do
      json = File.read(File.join(File.dirname(__FILE__),"fixtures/note.json"))
      allow(@master).to receive(:call).with('notes/1.json', :put, { note: { foo: :bar }}).and_return(JSON.load(json))
      expect(subject.update({ id: 1, note: { foo: :bar }})).to be_kind_of Contactually::Note
    end
  end

  describe '#destroy' do
    specify do
      expect{ subject.destroy() }.to raise_error Contactually::MissingParameterError
    end

    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('notes/1.json', :delete, { foo: :bar })
      subject.destroy({ id: 1, foo: :bar })
      expect(@master).to have_received(:call)
    end
  end
end
