require 'spec_helper'

describe Contactually::Groupings do

  before(:all) do
    Contactually.api_key = 'VALID_API_KEY'
    @master = Contactually::API.new
  end

  subject { described_class.new @master }

  describe '#initialize' do
    specify do
      expect(subject).to be_kind_of Contactually::Groupings
    end

    specify do
      expect(subject.instance_variable_get(:@master)).to be_kind_of Contactually::API
    end
  end

  describe '#index' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('groupings.json', :get, { foo: :bar }).and_return({ 'groupings' => [] })
      subject.index({ foo: :bar })
      expect(@master).to have_received(:call)
    end

    it 'returns groupings from json response' do
      json = File.read(File.join(File.dirname(__FILE__),"fixtures/groupings_index.json"))
      allow(@master).to receive(:call).with('groupings.json', :get, {}).and_return(JSON.load(json))
      expect(subject.index({})).to be_kind_of Array
      expect(subject.index({})[0]).to be_kind_of Contactually::Grouping
    end
  end

  describe '#create' do
    specify do
      expect{ subject.create }.to raise_error Contactually::MissingParameterError
    end

    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('groupings.json', :post, { grouping: { foo: :bar }}).and_return({ 'id' => 1234 })
      subject.create({ grouping: { foo: :bar }})
      expect(@master).to have_received(:call)
    end

    it 'returns groupings from json response' do
      json = File.read(File.join(File.dirname(__FILE__),"fixtures/grouping.json"))
      allow(@master).to receive(:call).with('groupings.json', :post, { grouping: { foo: :bar }}).and_return(JSON.load(json))
      expect(subject.create({ grouping: { foo: :bar }})).to be_kind_of Contactually::Grouping
    end
  end

  describe '#destroy' do
    it 'throws an error if grouping id is missing' do
      expect{ subject.destroy }.to raise_error Contactually::MissingParameterError
    end

    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('groupings/1.json', :delete, {})
      subject.destroy({ id: 1 })
      expect(@master).to have_received(:call)
    end
  end

  describe '#show' do
    it 'throws an error if grouping id is missing' do
      expect{ subject.show }.to raise_error Contactually::MissingParameterError
    end

    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('groupings/1.json', :get, { foo: :bar }).and_return({ id: 1234 })
      subject.show({ id: 1, foo: :bar })
      expect(@master).to have_received(:call)
    end

    it 'returns a grouping from json response' do
      json = File.read(File.join(File.dirname(__FILE__),"fixtures/grouping.json"))
      allow(@master).to receive(:call).with('groupings/1.json', :get, { foo: :bar }).and_return(JSON.load(json))
      expect(subject.show({ id: 1, foo: :bar })).to be_kind_of Contactually::Grouping
    end
  end

  describe '#update' do
    it 'throws an error if grouping id is missing' do
      expect{ subject.update }.to raise_error Contactually::MissingParameterError
    end

    it 'throws an error if grouping hash is missing' do
      expect{ subject.update({ id: 15 }) }.to raise_error Contactually::MissingParameterError
    end

    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('groupings/1.json', :put, { grouping: { foo: :bar }}).and_return({ id: 1234 })
      subject.update({ id: 1, grouping: { foo: :bar }})
      expect(@master).to have_received(:call)
    end

    it 'returns a grouping from json response' do
      json = File.read(File.join(File.dirname(__FILE__),"fixtures/grouping.json"))
      allow(@master).to receive(:call).with('groupings/1.json', :put, { grouping: { foo: :bar }}).and_return(JSON.load(json))
      expect(subject.update({ id: 1, grouping: { foo: :bar }})).to be_kind_of Contactually::Grouping
    end
  end
end
