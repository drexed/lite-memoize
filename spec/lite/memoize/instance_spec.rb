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
  subject { Lite::Memoize::Instance.new }

  let(:service) { InstanceFooService.new }

  describe '.[]' do
    it 'returns nil' do
      expect(subject[:field]).to eq(nil)
    end

    it 'returns "error message"' do
      subject[:field] = 'error message'

      expect(subject[:field]).to eq('error message')
    end
  end

  describe '.[]=' do
    it 'returns "error message"' do
      subject[:field] = 'error message'

      expect(subject[:field]).to eq('error message')
    end
  end

  describe '.clear' do
    it 'returns {}' do
      subject[:field] = 'error message'

      expect(subject.clear).to eq({})
    end
  end

  describe '.delete' do
    it 'returns {}' do
      subject[:field] = 'error message'
      subject.delete(:field)

      expect(subject.cache).to eq({})
    end
  end

  describe '.empty?' do
    it 'returns true' do
      expect(subject.empty?).to eq(true)
    end

    it 'returns false' do
      subject[:field] = 'error message'

      expect(subject.empty?).to eq(false)
    end
  end

  describe '.key?' do
    it 'returns false' do
      expect(subject.key?(:field)).to eq(false)
    end

    it 'returns true' do
      subject[:field] = 'error message'

      expect(subject.key?(:field)).to eq(true)
    end
  end

  describe '.keys' do
    it 'returns [:field]' do
      subject[:field] = 'error message'

      expect(subject.keys).to eq(%i[field])
    end
  end

  describe '.memoize' do
    it 'returns same string twice' do
      old_random_string = service.random
      new_random_string = service.random

      expect(old_random_string).to eq(new_random_string)
    end

    it 'returns different strings' do
      old_custom_string = service.custom
      new_custom_string = service.custom

      expect(old_custom_string).to_not eq(new_custom_string)
    end
  end

  describe '.merge!' do
    it 'returns { field: "other message" }' do
      subject[:field] = 'error message'
      subject.merge!(field: 'other message')

      expect(subject.cache).to eq({ field: 'other message' })
    end
  end

  describe '.present?' do
    it 'returns false' do
      expect(subject.present?).to eq(false)
    end

    it 'returns true' do
      subject[:field] = 'error message'

      expect(subject.present?).to eq(true)
    end
  end

  describe '.size' do
    it 'returns 0' do
      expect(subject.size).to eq(0)
    end

    it 'returns 1' do
      subject[:field] = 'error message'

      expect(subject.size).to eq(1)
    end
  end

  describe '.to_hash' do
    before { subject[:field] = 'error message' }

    it 'returns { field: "error message" }' do
      expect(subject.to_hash).to eq({ field: "error message" })
    end
  end

  describe '.values' do
    it 'returns ["error message"]' do
      subject[:field] = 'error message'

      expect(subject.values).to eq(['error message'])
    end
  end

end
