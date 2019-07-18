# frozen_string_literal: true

require 'memoist2'
require_relative 'base'

class Memoist2Cache

  include Memoist2

  def randomize
    rand(1..99)
  end

  memoize :randomize

end

klass_a = LiteMemoizeInstanceCache.new
klass_b = LiteMemoizeKlassCache.new
klass_c = LiteMemoizeMixinCache.new
klass_d = Memoist2Cache.new

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

  x.report('memoist2') do
    klass_d.randomize
  end

  x.compare!
end
