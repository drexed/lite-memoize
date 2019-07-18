# frozen_string_literal: true

%w[version alias mixin instance klass].each do |name|
  require "lite/memoize/#{name}"
end
