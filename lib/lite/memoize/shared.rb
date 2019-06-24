# frozen_string_literal: true

require 'digest'

module Lite
  module Memoize
    module Shared

      def cache
        @cache ||= {}
      end

      def key(method_name, method_args)
        return method_name.to_s if method_args.empty?

        method_sha1 = Digest::SHA1.hexdigest(method_args.to_s)
        "#{method_name}:#{method_sha1}"
      end

    end
  end
end
