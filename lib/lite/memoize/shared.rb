# frozen_string_literal: true

module Lite
  module Memoize
    module Shared

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

    end
  end
end
