# frozen_string_literal: true

module Lite
  module Memoize
    module Variable

      def memoize(method_name, args: nil, reload: false)
        key = "#{method_name}#{args}"
        var = "@#{key.gsub(/\W/, '') || key}"
        return instance_variable_get(var) if !reload && instance_variable_defined?(var)

        instance_variable_set(var, yield)
      end

    end
  end
end
