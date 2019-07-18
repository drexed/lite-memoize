# frozen_string_literal: true

require 'memoit'
require_relative 'base'

class MemoitCache

  memoize def randomize
    rand(1..99)
  end

end

klass_a = LiteMemoizeInstanceCache.new
klass_b = LiteMemoizeKlassCache.new
klass_c = LiteMemoizeMixinCache.new
klass_d = MemoitCache.new

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

  x.report('memoit') do
    klass_d.randomize
  end

  x.compare!
end
