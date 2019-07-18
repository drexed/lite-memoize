# frozen_string_literal: true

module Lite
  module Memoize
    module Mixin

      def store
        @store ||= {}
      end

      def caller_key(block, as: nil)
        name = as ? [as] : block.source_location
        return name.concat(block) if block.is_a?(Array)

        block.binding.local_variables.each_with_object(name) do |local_name, array|
          array << local_name
          array << block.binding.local_variable_get(local_name)
        end
      end

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
