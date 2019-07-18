# frozen_string_literal: true

module Lite
  module Memoize
    module Shared

      def cache
        @cache ||= {}
      end

      def caller_key(block, name = nil)
        name = [*(name || block.source_location)]
        return name.concat(block) if block.is_a?(Array)

        block.binding.local_variables.each_with_object(name) do |local_name, array|
          array << local_name
          array << block.binding.local_variable_get(local_name)
        end
      end

    end
  end
end
