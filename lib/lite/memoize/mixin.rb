# frozen_string_literal: true

module Lite
  module Memoize
    module Mixin

      def store
        @_memoized_methods ||= {}
      end

      def caller_key(block, as: nil)
        name = as ? [as] : block.source_location
        return name.concat(block) if block.is_a?(Array)

        block.binding.local_variables.each_with_object(name) do |local_name, array|
          array << local_name
          array << block.binding.local_variable_get(local_name)
        end
      end

      def memoize(method_name, args: nil, reload: false)
        key = "#{method_name}:#{args}"

        if reload
          store[key] = yield
        else
          store[key] ||= yield
        end
      end

    end
  end
end
