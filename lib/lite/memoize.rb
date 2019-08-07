# frozen_string_literal: true

%w[version alias table instance klass variable].each do |name|
  require "lite/memoize/#{name}"
end
