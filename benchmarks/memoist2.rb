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
klass_d = LiteMemoizeAliasCache.new
klass_z = Memoist2Cache.new

Benchmark.ips do |x|
  x.report('LM.instance') do
    klass_a.randomize
  end

  x.report('LM.klass') do
    klass_b.randomize
  end

  x.report('LM.mixin') do
    klass_c.randomize
  end

  x.report('LM.alias') do
    klass_d.randomize
  end

  x.report('Memoist2') do
    klass_z.randomize
  end

  x.compare!
end
