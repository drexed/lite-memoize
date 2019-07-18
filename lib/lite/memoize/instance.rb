# frozen_string_literal: true

module Lite
  module Memoize
    class Instance

      include Lite::Memoize::Shared

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
        key = caller_key(block, as)

        if refresh
          cache[key] = yield(block)
        else
          cache[key] ||= yield(block)
        end
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

    end
  end
end
