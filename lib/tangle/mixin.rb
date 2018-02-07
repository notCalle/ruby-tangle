require 'tangle/mixin/ancestry'
require 'tangle/mixin/connectedness'

module Tangle
  module Mixin
    #
    # Mixin to initialize the dynamic mixin system
    #
    module Initialize
      private

      def initialize_mixins(mixins = nil)
        case klass = self.class.name[/[^:]+$/].to_sym
        when :Graph
          @mixins = mixins
        else
          mixins = @graph.mixins unless @graph.nil?
        end

        extend_with_mixins(klass, mixins) unless mixins.nil?
      end

      def extend_with_mixins(klass, mixins)
        mixins.each do |mixin|
          extend(mixin.const_get(klass)) if mixin.const_defined?(klass)
        end
      end
    end
  end
end
