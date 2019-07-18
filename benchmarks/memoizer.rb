# frozen_string_literal: true

require 'memoizer'
require_relative 'base'

class MemoizerCache

  include Memoizer

  def randomize
    rand(1..99)
  end

  memoize :randomize

end

klass_a = LiteMemoizeInstanceCache.new
klass_b = LiteMemoizeKlassCache.new
klass_c = LiteMemoizeMixinCache.new
klass_d = MemoizerCache.new

Benchmark.ips do |x|
  x.report('instance') do
    klass_a.randomize
  end

  x.report('klass') do
    klass_b.randomize
  end

  x.report('mixin') do
    klass_c.randomize
  end

  x.report('memoizer') do
    klass_d.randomize
  end

  x.compare!
end
