# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

class MemoKlassService

  extend Lite::Memoize::Klass

  def custom
    SecureRandom.hex(10)
  end

  memoize :custom, as: 'custom_name'

  def random(length = 10)
    SecureRandom.hex(length)
  end

  memoize :random

end

RSpec.describe Lite::Memoize::Klass do
  let(:service) { MemoKlassService.new }

  describe '.memoize' do
    it 'to be same string twice' do
      old_random_string = service.random
      new_random_string = service.random

      expect(old_random_string).to eq(new_random_string)
    end

    it 'to be hash key with custom name' do
      old_custom_string = service.custom
      new_custom_string = service.custom

      expect(old_custom_string).to eq(new_custom_string)
    end
  end

end
