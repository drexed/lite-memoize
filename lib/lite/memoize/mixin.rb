# frozen_string_literal: true

module Lite
  module Memoize
    module Mixin

      include Lite::Memoize::Shared

      def memoize(method_name, args: nil, refresh: false)
        key = "#{method_name}:#{args}"

        if refresh
          store[key] = yield
        else
          store[key] ||= yield
        end
      end

    end
  end
end
