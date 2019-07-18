# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

class KlassFooService

  include Lite::Memoize::Mixin

  def random
    memoize(:random) { SecureRandom.hex(10) }
  end

end

RSpec.describe Lite::Memoize::Mixin do
  let(:klass) { KlassFooService.new }
  let(:foo) { klass }

  describe '.store' do
    it 'to be {}' do
      expect(foo.store).to eq({})
    end
  end

  describe '.caller_key' do
    it 'to be ["random", 1, {}, []]' do
      expect(klass.caller_key([1, {}, []], as: 'random')).to eq(['random', 1, {}, []])
    end

    it 'to be "random"' do
      expect(klass.caller_key([], as: 'random')).to eq(['random'])
    end
  end

  describe '.memoize' do
    it 'to be same string twice' do
      old_random_string = klass.random
      new_random_string = klass.random

      expect(old_random_string).to eq(new_random_string)
    end
  end

end
