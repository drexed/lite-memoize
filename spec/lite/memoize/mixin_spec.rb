# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

class MemoMixinService

  include Lite::Memoize::Mixin

  def custom
    memoize(:random, reload: true) { SecureRandom.hex(10) }
  end

  def random
    memoize(:random) { SecureRandom.hex(10) }
  end

  alias rando random

end

RSpec.describe Lite::Memoize::Mixin do
  let(:service) { MemoMixinService.new }

  describe '.store' do
    it 'to be {}' do
      expect(service.store).to eq({})
    end
  end

  describe '.caller_key' do
    it 'to be ["random", 1, {}, []]' do
      expect(service.caller_key([1, {}, []], as: 'random')).to eq(['random', 1, {}, []])
    end

    it 'to be "random"' do
      expect(service.caller_key([], as: 'random')).to eq(['random'])
    end
  end

  describe '.memoize' do
    it 'to be same string twice' do
      old_random_string = service.random
      new_random_string = service.random

      expect(old_random_string).to eq(new_random_string)
    end

    it 'to be same string twice for aliased method' do
      old_random_string = service.random
      new_random_string = service.rando

      expect(old_random_string).to eq(new_random_string)
    end

    it 'to be different strings' do
      old_custom_string = service.custom
      new_custom_string = service.custom

      expect(old_custom_string).not_to eq(new_custom_string)
    end
  end

end
