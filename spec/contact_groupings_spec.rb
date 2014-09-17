require 'spec_helper'

describe Contactually::ContactGroupings do

  let(:grouping_json) { File.read(File.join(File.dirname(__FILE__),"fixtures/grouping.json")) }

  before(:all) do
    Contactually.configure { |c| c.api_key = 'VALID_API_KEY' }
    @master = Contactually::API.new
  end

  subject { described_class.new @master }
  describe '#initialize' do
    specify do
      expect(subject).to be_kind_of Contactually::ContactGroupings
    end

    specify do
      expect(subject.instance_variable_get(:@master)).to be_kind_of Contactually::API
    end
  end


  describe '#create' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contacts/1/groupings.json', :post, { grouping_id: 512 }).and_return({ 'id' => 1234 })
      subject.create(1, { grouping_id: 512 })
      expect(@master).to have_received(:call)
    end

    it 'returns grouping from json response' do
      allow(@master).to receive(:call).with('contacts/1/groupings.json', :post, { grouping_id: 512 }).and_return(JSON.load(grouping_json))
      expect(subject.create(1, { grouping_id: 512 })).to be_kind_of Contactually::Grouping
    end
  end

  describe '#destroy' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('contacts/1/groupings/15.json', :delete, { foo: :bar }).and_return({ 'success' => true })
      subject.destroy(1, 15, { foo: :bar })
      expect(@master).to have_received(:call)
    end
  end
end
