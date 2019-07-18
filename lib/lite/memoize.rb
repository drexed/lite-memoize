# frozen_string_literal: true

%w[version shared instance klass mixin].each do |name|
  require "lite/memoize/#{name}"
end
