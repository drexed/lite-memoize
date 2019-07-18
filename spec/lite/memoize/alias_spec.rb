# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

class MemoAliasService

  extend Lite::Memoize::Alias

  class << self

    extend Lite::Memoize::Alias

    def class_random(length = 10)
      SecureRandom.hex(length)
    end

    memoize :class_random

  end

  def custom
    SecureRandom.hex(10)
  end

  memoize :custom, as: 'custom_name'

  def random(length = 10)
    SecureRandom.hex(length)
  end

  memoize :random

  protected

  def protected_random(length = 10)
    SecureRandom.hex(length)
  end

  memoize :protected_random

  private

  def private_random(length = 10)
    SecureRandom.hex(length)
  end

  memoize :private_random

end

RSpec.describe Lite::Memoize::Alias do
  let(:klass) { MemoAliasService }
  let(:service) { klass.new }

  describe '.memoize' do
    it 'to be same string twice for class method' do
      old_random_string = klass.class_random
      new_random_string = klass.class_random

      expect(old_random_string).to eq(new_random_string)
    end

    it 'to be same string twice for public method' do
      old_random_string = service.random
      new_random_string = service.random

      expect(old_random_string).to eq(new_random_string)
    end

    it 'to be same string twice for protected method' do
      old_random_string = service.send(:protected_random)
      new_random_string = service.send(:protected_random)

      expect(old_random_string).to eq(new_random_string)
    end

    it 'to be same string twice for private method' do
      old_random_string = service.send(:private_random)
      new_random_string = service.send(:private_random)

      expect(old_random_string).to eq(new_random_string)
    end

    it 'to be same string twice with custom name' do
      old_custom_string = service.custom
      new_custom_string = service.custom

      expect(old_custom_string).to eq(new_custom_string)
    end

    it 'to be different strings' do
      old_random_string = service.custom
      new_random_string = service.custom(reload: true)

      expect(old_random_string).not_to eq(new_random_string)
    end
  end

end
