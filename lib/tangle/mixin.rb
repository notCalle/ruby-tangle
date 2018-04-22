module Tangle
  module Mixin
    #
    # Mixin to initialize the dynamic mixin system
    #
    module Initialize
      attr_reader :mixins

      private

      def initialize_mixins(mixins = nil, **kwargs)
        case klass = self.class.name[/[^:]+$/].to_sym
        when :Graph
          @mixins = mixins
        else
          mixins = @graph.mixins unless @graph.nil?
        end

        extend_with_mixins(klass, mixins) unless mixins.nil?
        initialize_kwargs(**kwargs) unless kwargs.empty?
      end

      def extend_with_mixins(klass, mixins)
        mixins.each do |mixin|
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
