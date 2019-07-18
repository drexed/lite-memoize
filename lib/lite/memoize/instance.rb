# frozen_string_literal: true

module Lite
  module Memoize
    class Instance

      include Lite::Memoize::Mixin

      def initialize; end

      def [](key)
        store[key]
      end

      def []=(key, val)
        store[key] = val
      end

      def clear
        store.clear
      end

      alias flush clear

      def delete(key)
        store.delete(key)
      end

      # :nocov:
      def each
        store.each { |key, val| yield(key, val) }
      end
      # :nocov:

      def empty?
        store.empty?
      end

      alias blank? empty?

      def key?(key)
        store.key?(key)
      end

      alias hit? key?

      def keys
        store.keys
      end

      def merge!(hash)
        store.merge!(hash)
      end

      def memoize(as: nil, args: nil, reload: false, &block)
        key = caller_key(args || block, as: as)

        if reload
          store[key] = yield
        else
          store[key] ||= yield
        end
      end

      def present?
        !blank?
      end

      alias hits? present?

      def size
        store.size
      end

      def slice!(*keys)
        keys.each { |key| store.delete(key) }
        store
      end

      def to_hash
        store
      end

      alias as_json to_hash
      alias hits to_hash

      def values
        store.values
      end

    end
  end
end
