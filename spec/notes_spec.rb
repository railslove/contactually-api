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
    end

    it 'returns notes from json response' do
      json = File.read(File.join(File.dirname(__FILE__),"fixtures/notes_index.json"))
      allow(@master).to receive(:call).with('notes.json', :get, {}).and_return(JSON.load(json))
      expect(subject.index({})).to be_kind_of Array
      expect(subject.index({})[0]).to be_kind_of Contactually::Note
    end
  end
end