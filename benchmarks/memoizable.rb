# frozen_string_literal: true

require 'memoizable'
require_relative 'base'

# NOTE: This lib is a bit faster because it doesn't support args of refreshing support

class MemoizableCache

  include Memoizable

  def randomize
    rand(1..99)
  end

  memoize :randomize

end

klass_a = LiteMemoizeInstanceCache.new
klass_b = LiteMemoizeKlassCache.new
klass_c = LiteMemoizeMixinCache.new
klass_d = MemoizableCache.new

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

  x.report('memoizable') do
    klass_d.randomize
  end

  x.compare!
end
