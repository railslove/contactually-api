require 'spec_helper'

describe Contactually::Tasks do

  let(:task_json) { File.read(File.join(File.dirname(__FILE__),"fixtures/task.json")) }
  let(:tasks_index_json) { File.read(File.join(File.dirname(__FILE__),"fixtures/tasks_index.json")) }

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
      allow(@master).to receive(:call).with('tasks/1.json', :get, { foo: :bar }).and_return(JSON.load(task_json))
      subject.show(1, { foo: :bar })
      expect(@master).to have_received(:call)
    end

    it 'returns a task' do
      allow(@master).to receive(:call).with('tasks/1.json', :get, { foo: :bar }).and_return(JSON.load(task_json))
      expect(subject.show(1, { foo: :bar })).to be_kind_of Contactually::Task
    end
  end

  describe '#complete' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('tasks/1/complete.json', :post, { foo: :bar }).and_return(JSON.load(task_json))
      subject.complete(1, { foo: :bar })
      expect(@master).to have_received(:call)
    end

    it 'returns a task' do
      allow(@master).to receive(:call).with('tasks/1/complete.json', :post, { foo: :bar }).and_return(JSON.load(task_json))
      expect(subject.complete(1, { foo: :bar })).to be_kind_of Contactually::Task
    end
  end

  describe '#create' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('tasks.json', :post, { foo: :bar }).and_return(JSON.load(task_json))
      subject.create({ foo: :bar })
      expect(@master).to have_received(:call)
    end

    it 'returns a new task' do
      allow(@master).to receive(:call).with('tasks.json', :post, { foo: :bar }).and_return(JSON.load(task_json))
      expect(subject.create({ foo: :bar })).to be_kind_of Contactually::Task
    end
  end

  describe '#update' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('tasks/1.json', :put, { foo: :bar }).and_return(JSON.load(task_json))
      subject.update(1, { foo: :bar })
      expect(@master).to have_received(:call)
    end

    it 'returns a new task' do
      allow(@master).to receive(:call).with('tasks/1.json', :put, { foo: :bar }).and_return(JSON.load(task_json))
      expect(subject.update(1, { foo: :bar })).to be_kind_of Contactually::Task
    end
  end

  describe '#destroy' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('tasks/1.json', :delete, { foo: :bar }).and_return(JSON.load('{ "deleted": true }'))
      subject.destroy(1, { foo: :bar })
      expect(@master).to have_received(:call)
    end
  end

  describe '#generate_followups' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('tasks/generate_followups.json', :post, { foo: :bar }).and_return(JSON.load('{ "deleted": true }'))
      subject.generate_followups({ foo: :bar })
      expect(@master).to have_received(:call)
    end
  end

  describe '#generate_followups' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('tasks/1/snooze.json', :post, { foo: :bar }).and_return(JSON.load('{ "snooze": true }'))
      subject.snooze(1, { foo: :bar })
      expect(@master).to have_received(:call)
    end
  end

  describe '#ignore' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('tasks/1/ignore.json', :post, { foo: :bar }).and_return(JSON.load(task_json))
      subject.ignore(1, { foo: :bar })
      expect(@master).to have_received(:call)
    end

    it 'returns a new task' do
      allow(@master).to receive(:call).with('tasks/1/ignore.json', :post, { foo: :bar }).and_return(JSON.load(task_json))
      expect(subject.ignore(1, { foo: :bar })).to be_kind_of Contactually::Task
    end
  end

  describe '#index' do
    it 'calls the api with correct params' do
      allow(@master).to receive(:call).with('tasks.json', :get, { foo: :bar }).and_return({ 'tasks' => [] })
      subject.index({ foo: :bar })
      expect(@master).to have_received(:call)
    end

    it 'returns tasks from json response' do
      allow(@master).to receive(:call).with('tasks.json', :get, {}).and_return(JSON.load(tasks_index_json))
      expect(subject.index({})).to be_kind_of Array
      expect(subject.index({})[0]).to be_kind_of Contactually::Task
    end
  end

end
