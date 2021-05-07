# frozen_string_literal: true

module Lite
  module Memoize
    module Klass

      include Lite::Memoize::Table

      def memoize(method_name, as: nil)
        inner_method = instance_method(method_name)

        define_method(method_name) do |*args|
          key = self.class.caller_key(args, as: as || method_name)

          self.class.store[key] ||= inner_method.bind_call(self, *args)
        end
      end

      public :caller_key

    end
  end
end
