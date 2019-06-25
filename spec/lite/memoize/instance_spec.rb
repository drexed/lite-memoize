# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

class InstanceFooService

  def cache
    @cache ||= Lite::Memoize::Instance.new
  end

  def custom
    cache.memoize(as: 'custom_name', refresh: true) do
      SecureRandom.hex(10)
    end
  end

  def fixed
    cache.memoize do
      SecureRandom.hex(10)
    end
  end

  def random(length = 10)
    cache.memoize do
      SecureRandom.hex(length)
    end
  end

end

RSpec.describe Lite::Memoize::Instance do
  let(:klass) { described_class.new }
  let(:foo) { InstanceFooService.new }

  describe '.[]' do
    it 'to be nil' do
      expect(klass[:field]).to eq(nil)
    end

    it 'to be "error message"' do
      klass[:field] = 'error message'

      expect(klass[:field]).to eq('error message')
    end
  end

  describe '.[]=' do
    it 'to be "error message"' do
      klass[:field] = 'error message'

      expect(klass[:field]).to eq('error message')
    end
  end

  describe '.clear' do
    it 'to be {}' do
      klass[:field] = 'error message'

      expect(klass.clear).to eq({})
    end
  end

  describe '.delete' do
    it 'to be "error message"' do
      klass[:field] = 'error message'

      expect(klass.delete(:field)).to eq('error message')
    end
  end

  describe '.empty?' do
    it 'to be true' do
      expect(klass.empty?).to eq(true)
    end

    it 'to be false' do
      klass[:field] = 'error message'

      expect(klass.empty?).to eq(false)
    end
  end

  describe '.key?' do
    it 'to be false' do
      expect(klass.key?(:field)).to eq(false)
    end

    it 'to be true' do
      klass[:field] = 'error message'

      expect(klass.key?(:field)).to eq(true)
    end
  end

  describe '.keys' do
    it 'to be [:field]' do
      klass[:field] = 'error message'

      expect(klass.keys).to eq(%i[field])
    end
  end

  describe '.memoize' do
    it 'to be same string twice' do
      old_random_string = foo.random
      new_random_string = foo.random

      expect(old_random_string).to eq(new_random_string)
    end

    it 'to be different strings' do
      old_custom_string = foo.custom
      new_custom_string = foo.custom

      expect(old_custom_string).not_to eq(new_custom_string)
    end
  end

  # rubocop:disable Performance/RedundantMerge
  describe '.merge!' do
    it 'to be { field: "other message" }' do
      # Skip fasterer error: Hash#merge!

      klass[:field] = 'error message'
      klass.merge!(field: 'other message')

      expect(klass.cache).to eq(field: 'other message')
    end
  end
  # rubocop:enable Performance/RedundantMerge

  describe '.present?' do
    it 'to be false' do
      expect(klass.present?).to eq(false)
    end

    it 'to be true' do
      klass[:field] = 'error message'

      expect(klass.present?).to eq(true)
    end
  end

  describe '.size' do
    it 'to be 0' do
      expect(klass.size).to eq(0)
    end

    it 'to be 1' do
      klass[:field] = 'error message'

      expect(klass.size).to eq(1)
    end
  end

  describe '.slice!' do
    it 'to be {}' do
      klass[:field] = 'error message'

      expect(klass.slice!(:field)).to eq({})
    end
  end

  describe '.to_hash' do
    before { klass[:field] = 'error message' }

    it 'to be { field: "error message" }' do
      expect(klass.to_hash).to eq(field: 'error message')
    end
  end

  describe '.values' do
    it 'to be ["error message"]' do
      klass[:field] = 'error message'

      expect(klass.values).to eq(['error message'])
    end
  end

end
