# frozen_string_literal: true

require 'spec_helper'

class SharedFooService

  extend Lite::Memoize::Shared

end

RSpec.describe Lite::Memoize::Shared do
  let(:klass) { SharedFooService.new }
  let(:foo) { SharedFooService }

  describe '.store' do
    it 'to be {}' do
      expect(foo.store).to eq({})
    end
  end

  describe '.caller_key' do
    it 'to be ["random", 1, {}, []]' do
      expect(foo.caller_key([1, {}, []], as: 'random')).to eq(['random', 1, {}, []])
    end

    it 'to be "random"' do
      expect(foo.caller_key([], as: 'random')).to eq(['random'])
    end
  end

end
