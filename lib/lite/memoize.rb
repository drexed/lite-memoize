# frozen_string_literal: true

%w[version shared klass instance].each do |name|
  require "lite/memoize/#{name}"
end
