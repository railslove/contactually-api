require 'spec_helper'

describe Contactually::Groupings do

  let(:groupings_index_json) { File.read(File.join(File.dirname(__FILE__),"fixtures/groupings_index.json")) }
  let(:grouping_json) { File.read(File.join(File.dirname(__FILE__),"fixtures/grouping.json")) }
  let(:groupings_statistics_json) { File.read(File.join(File.dirname(__FILE__), "fixtures/groupings_statistics.json")) }

  before(:all) do
    Contactually.configure { |c| c.api_key = 'VALID_API_KEY' }
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
      allow(@master).to receive(:call).with('groupings.json', :get, {}).and_return(JSON.load(groupings_index_json))
      expect(subject.index({})).to be_kind_of Array
      expect(subject.index({})[0]).to be_kind_of Contactually::Grouping
    end
  end

  describe '#create' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('groupings.json', :post, { grouping: { foo: :bar }}).and_return({ 'id' => 1234 })
      subject.create({ grouping: { foo: :bar }})
      expect(@master).to have_received(:call)
    end

    it 'returns groupings from json response' do
      allow(@master).to receive(:call).with('groupings.json', :post, { grouping: { foo: :bar }}).and_return(JSON.load(grouping_json))
      expect(subject.create({ grouping: { foo: :bar }})).to be_kind_of Contactually::Grouping
    end
  end

  describe '#destroy' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('groupings/1.json', :delete, {})
      subject.destroy(1)
      expect(@master).to have_received(:call)
    end
  end

  describe '#show' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('groupings/1.json', :get, { foo: :bar }).and_return({ id: 1234 })
      subject.show(1, { foo: :bar })
      expect(@master).to have_received(:call)
    end

    it 'returns a grouping from json response' do
      allow(@master).to receive(:call).with('groupings/1.json', :get, { foo: :bar }).and_return(JSON.load(grouping_json))
      expect(subject.show(1, { foo: :bar })).to be_kind_of Contactually::Grouping
    end
  end

  describe '#update' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('groupings/1.json', :put, { grouping: { foo: :bar }}).and_return({ id: 1234 })
      subject.update(1, { grouping: { foo: :bar }})
      expect(@master).to have_received(:call)
    end

    it 'returns a grouping from json response' do
      allow(@master).to receive(:call).with('groupings/1.json', :put, { grouping: { foo: :bar }}).and_return(JSON.load(grouping_json))
      expect(subject.update(1, { grouping: { foo: :bar }})).to be_kind_of Contactually::Grouping
    end
  end

  describe '#statistics' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('groupings/1/statistics.json', :get, { foo: :bar }).and_return({ 'messages_sent' => 10 })
      subject.statistics(1, { foo: :bar })
      expect(@master).to have_received(:call)
    end

    it 'returns statistics object' do
      allow(@master).to receive(:call).with('groupings/1/statistics.json', :get, { foo: :bar }).and_return(JSON.load(groupings_statistics_json))
      expect(subject.statistics(1, { foo: :bar })).to be_kind_of Contactually::GroupingStatistic
    end
  end
end
