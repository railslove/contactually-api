require 'spec_helper'

describe Contactually::Utils do
  subject { described_class }

  describe '#params_without_id' do
    specify do
      expect(subject.send(:params_without_id, { id: 1, foo: :bar })).to eq({ foo: :bar })
    end
  end
end
