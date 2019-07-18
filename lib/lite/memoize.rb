# frozen_string_literal: true

%w[version mixin instance klass].each do |name|
  require "lite/memoize/#{name}"
end
