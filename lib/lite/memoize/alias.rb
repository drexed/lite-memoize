# frozen_string_literal: true

module Lite
  module Memoize
    module Alias

      MemoizedMethod = Struct.new(:memoized_method, :ivar, :arity)

      module InstanceMethods

        def memoized_structs(names)
          ref_obj = self.class.respond_to?(:class_eval) ? singleton_class : self
          structs = ref_obj.all_memoized_structs
          return structs if names.empty?

          structs.select { |s| names.include?(s.memoized_method) }
        end

        def memoize_all(*method_names)
          memoized_structs(method_names).each do |struct|
            if struct.arity.zero?
              __send__(struct.memoized_method)
            else
              instance_variable_set(struct.ivar, {})
            end
          end
        end

        def clear_cache(*method_names)
          memoized_structs(method_names).each do |struct|
            next unless instance_variable_defined?(struct.ivar)

            remove_instance_variable(struct.ivar)
          end
        end

        alias flush_cache clear_cache

      end

      class << self

        # rubocop:disable Lint/NestedMethodDefinition
        def extended(extender)
          Lite::Memoize::Alias.memoist_eval(extender) do
            return if singleton_class.method_defined?(:memoized_methods)

            def self.memoized_methods
              @_memoized_methods ||= []
            end
          end
        end
        # rubocop:enable Lint/NestedMethodDefinition

        def memoized_ivar_for(method_name, as = nil)
          "@#{memoized_prefix(as)}_#{escape_punctuation(method_name)}"
        end

        def unmemoized_method_for(method_name, as = nil)
          "#{unmemoized_prefix(as)}_#{method_name}".to_sym
        end

        def memoized_prefix(as = nil)
          return '_memoized' unless as

          "_memoized_#{as}"
        end

        def unmemoized_prefix(as = nil)
          return '_unmemoized' unless as

          "_unmemoized_#{as}"
        end

        def escape_punctuation(string)
          string = string.is_a?(String) ? string.dup : string.to_s
          return string unless string.end_with?('?', '!')

          string.sub!(/\?\Z/, '_query') || string.sub!(/!\Z/, '_bang') || string
        end

        def memoist_eval(klass, *args, &block)
          return klass.class_eval(*args, &block) if klass.respond_to?(:class_eval)

          klass.singleton_class.class_eval(*args, &block)
        end

      end

      def all_memoized_structs
        @all_memoized_structs ||= begin
          structs = memoized_methods.dup

          ancestors.grep(Lite::Memoize::Alias).each do |ancestor|
            ancestor.memoized_methods.each do |m|
              next if structs.any? { |am| am.memoized_method == m.memoized_method }

              structs << m
            end
          end

          structs
        end
      end

      def clear_structs
        @all_memoized_structs = nil
      end

      # rubocop:disable Metrics/AbcSize, Metrics/BlockLength, Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/MethodLength, Metrics/PerceivedComplexity
      def memoize(*method_names)
        as = method_names.pop[:as] if method_names.last.is_a?(Hash)

        method_names.each do |method_name|
          unmemoized_method = Lite::Memoize::Alias.unmemoized_method_for(method_name, as)
          memoized_ivar = Lite::Memoize::Alias.memoized_ivar_for(method_name, as)

          Lite::Memoize::Alias.memoist_eval(self) do
            include InstanceMethods

            # rubocop:disable Lint/NonLocalExitFromIterator
            if method_defined?(unmemoized_method)
              warn "Already memoized #{method_name}"
              return
            end
            # rubocop:enable Lint/NonLocalExitFromIterator

            alias_method unmemoized_method, method_name

            mm = MemoizedMethod.new(method_name, memoized_ivar, instance_method(method_name).arity)
            memoized_methods << mm

            if mm.arity.zero?
              module_eval <<-RUBY, __FILE__, __LINE__ + 1
                def #{method_name}(reload: false)
                  skip_cache = reload || !instance_variable_defined?("#{memoized_ivar}")
                  set_cache = skip_cache && !frozen?

                  if skip_cache
                    value = #{unmemoized_method}
                  else
                    value = #{memoized_ivar}
                  end

                  if set_cache
                    #{memoized_ivar} = value
                  end

                  value
                end
              RUBY
            else
              module_eval <<-RUBY, __FILE__, __LINE__ + 1
                def #{method_name}(*args, reload: false)
                  skip_cache = reload || !(instance_variable_defined?(#{memoized_ivar.inspect}) && #{memoized_ivar} && #{memoized_ivar}.key?(args))
                  set_cache = skip_cache && !frozen?

                  if skip_cache
                    value = #{unmemoized_method}(*args)
                  else
                    value = #{memoized_ivar}[args]
                  end

                  if set_cache
                    #{memoized_ivar} ||= {}
                    #{memoized_ivar}[args] = value
                  end

                  value
                end
              RUBY
            end

            if private_method_defined?(unmemoized_method)
              private method_name
            elsif protected_method_defined?(unmemoized_method)
              protected method_name
            end
          end
        end

        method_names.size == 1 ? method_names.first : method_names
      end
      # rubocop:enable Metrics/MethodLength, Metrics/PerceivedComplexity
      # rubocop:enable Metrics/AbcSize, Metrics/BlockLength, Metrics/CyclomaticComplexity

    end
  end
end
