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

  describe '.memoize' do
    it 'to be same string twice' do
      old_random_string = klass.random
      new_random_string = klass.random

      expect(old_random_string).to eq(new_random_string)
    end
  end

end
