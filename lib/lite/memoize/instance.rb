# frozen_string_literal: true

module Lite
  module Memoize
    class Instance

      include Lite::Memoize::Shared

      CALLER_METHOD_REGEX ||= /`([^']*)'/.freeze

      def initialize; end

      def [](key)
        cache[key]
      end

      def []=(key, val)
        cache[key] = val
      end

      def clear
        cache.clear
      end

      def delete(key)
        cache.delete(key)
      end

      # :nocov:
      def each
        cache.each { |key, val| yield(key, val) }
      end
      # :nocov:

      def empty?
        cache.empty?
      end

      alias blank? empty?

      def key?(key)
        cache.key?(key)
      end

      alias hit? key?

      def keys
        cache.keys
      end

      def merge!(hash)
        cache.merge!(hash)
      end

      def memoize(as: nil, refresh: false, &block)
        key = key(as || caller_method, caller_locals(block))
        return cache[key] if !refresh && cache.key?(key)

        cache[key] = yield(block)
      end

      def present?
        !blank?
      end

      alias hits? present?

      def size
        cache.size
      end

      def slice!(*keys)
        keys.each { |key| cache.delete(key) }
        cache
      end

      def to_hash
        cache
      end

      alias as_json to_hash
      alias hits to_hash

      def values
        cache.values
      end

      private

      def caller_locals(block)
        local_vars = block.binding.local_variables
        local_vars.flat_map { |name| [name, block.binding.local_variable_get(name)] }
      end

      def caller_method
        val = caller(2..2).first[CALLER_METHOD_REGEX, 1]
        return val unless val.include?('<top (required)>')

        caller(1..1).first[CALLER_METHOD_REGEX, 1]
      end

    end
  end
end
