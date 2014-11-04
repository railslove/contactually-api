require 'spec_helper'

describe Contactually::Middleware::ErrorDetector do

  describe '#cast_error' do

    it 'detects invalid parameter errors' do
      body = { error: 'Invalid parameters' }.to_json
      expect{ subject.send(:cast_error, body) }.to raise_error Contactually::InvalidParametersError
    end

    it 'detects duplication errors' do
      body = { error: 'We already have' }.to_json
      expect{ subject.send(:cast_error, body) }.to raise_error Contactually::DuplicatedContactError
    end

    it 'rescues json parse errors' do
      body = ";foobar;"
      expect{ subject.send(:cast_error, body) }.to raise_error Contactually::APIError
    end 

  end

end
