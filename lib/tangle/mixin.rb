# frozen_string_literal: true

module Tangle
  module Mixin
    #
    # Mixin to initialize the dynamic mixin system
    #
    module Initialize
      attr_reader :mixins

      private

      def initialize_mixins(mixins: nil, **kwargs)
        @mixins = mixins || self.class::DEFAULT_MIXINS

        extend_with_mixins unless @mixins.nil?
        initialize_kwargs(**kwargs) unless kwargs.empty?
      end

      def extend_with_mixins
        klass = self.class.name[/[^:]+$/].to_sym
        @mixins.each do |mixin|
          extend(mixin.const_get(klass)) if mixin.const_defined?(klass)
        end
      end

      def initialize_kwargs(**kwargs)
        kwargs.each do |keyword, argument|
          send("initialize_kwarg_#{keyword}", argument)
        end
      end
    end
  end
end
