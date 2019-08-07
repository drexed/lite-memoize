# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

class MemoVariableService

  include Lite::Memoize::Variable

  def custom
    memoize(:custom, reload: true) { SecureRandom.hex(10) }
  end

  def random
    memoize(:random) { SecureRandom.hex(10) }
  end

  alias rando random

end

RSpec.describe Lite::Memoize::Variable do
  let(:klass) { described_class.new }
  let(:service) { MemoVariableService.new }

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
