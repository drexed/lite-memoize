# frozen_string_literal: true

require 'spec_helper'

class SharedFooService

  extend Lite::Memoize::Shared

end

RSpec.describe Lite::Memoize::Shared do
  let(:klass) { SharedFooService.new }
  let(:foo) { SharedFooService }

  describe '.cache' do
    it 'returns {}' do
      expect(foo.cache).to eq({})
    end
  end

  describe '.key' do
    key = 'random:dd7878149a8196d5b21abf3f51532dd46d79c471'

    it "returns '#{key}'" do
      expect(foo.key('random', [1, {}, []])).to eq(key)
    end

    it 'returns "random"' do
      expect(foo.key('random', [])).to eq('random')
    end
  end

end
