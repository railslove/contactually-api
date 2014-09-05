require 'spec_helper'

describe Contactually::Tasks do

  before(:all) do
    Contactually.configure { |c| c.api_key = 'VALID_API_KEY' }
    @master = Contactually::API.new
  end

  subject { described_class.new @master }
  describe '#initialize' do
    specify do
      expect(subject).to be_kind_of Contactually::Tasks
    end

    specify do
      expect(subject.instance_variable_get(:@master)).to be_kind_of Contactually::API
    end
  end

  describe '#show' do
    it 'calls the api with correct params' do
      json = File.read(File.join(File.dirname(__FILE__),"fixtures/task.json"))
      allow(@master).to receive(:call).with('tasks/1.json', :get, { foo: :bar }).and_return(JSON.load(json))
      subject.show(1, { foo: :bar })
      expect(@master).to have_received(:call)
    end

    it 'returns a task' do
      json = File.read(File.join(File.dirname(__FILE__),"fixtures/task.json"))
      allow(@master).to receive(:call).with('tasks/1.json', :get, { foo: :bar }).and_return(JSON.load(json))
      expect(subject.show(1, { foo: :bar })).to be_kind_of Contactually::Task
    end
  end

end
