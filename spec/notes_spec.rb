require 'spec_helper'

describe Contactually::Notes do

  let(:notes_index_json) { File.read(File.join(File.dirname(__FILE__),"fixtures/notes_index.json")) }
  let(:note_json) { File.read(File.join(File.dirname(__FILE__),"fixtures/note.json")) }

  before(:all) do
    Contactually.configure { |c| c.api_key = 'VALID_API_KEY' }
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
      allow(@master).to receive(:call).with('notes.json', :get, {}).and_return(JSON.load(notes_index_json))
      expect(subject.index({})).to be_kind_of Array
      expect(subject.index({})[0]).to be_kind_of Contactually::Note
    end
  end

  describe '#show' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('notes/1.json', :get, { foo: :bar }).and_return(JSON.load(note_json))
      subject.show(1, { foo: :bar })
      expect(@master).to have_received(:call)
    end

    it 'returns a note' do
      allow(@master).to receive(:call).with('notes/1.json', :get, { foo: :bar }).and_return(JSON.load(note_json))
      expect(subject.show(1, { foo: :bar })).to be_kind_of Contactually::Note
    end
  end

  describe '#create' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('notes.json', :post, { note: { foo: :bar }}).and_return(JSON.load(note_json))
      subject.create({ note: { foo: :bar }})
      expect(@master).to have_received(:call)
    end

    it 'returns a note' do
      allow(@master).to receive(:call).with('notes.json', :post, { note: { foo: :bar }}).and_return(JSON.load(note_json))
      expect(subject.create({ note: { foo: :bar }})).to be_kind_of Contactually::Note
    end
  end

  describe '#update' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('notes/1.json', :put, { note: { foo: :bar }}).and_return(JSON.load(note_json))
      subject.update(1, { note: { foo: :bar }})
      expect(@master).to have_received(:call)
    end

    it 'returns a note' do
      allow(@master).to receive(:call).with('notes/1.json', :put, { note: { foo: :bar }}).and_return(JSON.load(note_json))
      expect(subject.update(1, { note: { foo: :bar }})).to be_kind_of Contactually::Note
    end
  end

  describe '#destroy' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('notes/1.json', :delete, { foo: :bar })
      subject.destroy(1, { foo: :bar })
      expect(@master).to have_received(:call)
    end
  end
end
