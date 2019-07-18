# frozen_string_literal: true

%w[lib benchmarks].each { |name| $LOAD_PATH.unshift(name) }

require 'benchmark/ips'
require 'lite/memoize'

class LiteMemoizeInstanceCache

  def cache
    @cache ||= Lite::Memoize::Instance.new
  end

  def randomize
    cache.memoize { rand(1..99) }
  end

end

class LiteMemoizeKlassCache

  extend Lite::Memoize::Klass

  def randomize
    rand(1..99)
  end

  memoize :randomize

end

class LiteMemoizeMixinCache

  include Lite::Memoize::Mixin

  def randomize
    memoize(:randomize) { rand(1..99) }
  end

end
