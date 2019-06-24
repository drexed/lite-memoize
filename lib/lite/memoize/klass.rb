# frozen_string_literal: true

module Lite
  module Memoize
    module Klass

      include Lite::Memoize::Shared

      def memoize(method_name, as: nil)
        inner_method = instance_method(method_name)

        define_method(method_name) do |*args|
          key = self.class.key(as || method_name, args)
          self.class.cache[key] ||= inner_method.bind(self).call(*args)
        end
      end

    end
  end
end
