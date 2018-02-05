require 'tangle/mixin/connectedness'

module Tangle
  module Mixin
    #
    # Mixin to initialize the dynamic mixin system
    #
    module Initialize
      private

      def initialize_mixins(mixins = nil)
        klass = self.class.name[/[^:]+$/].to_sym
        @mixins = mixins unless mixins.nil?
        mixins ||= @graph.mixins unless @graph.nil?

        return if mixins.nil?

        mixins.each do |mixin|
          extend(mixin.const_get(klass)) if mixin.const_defined?(klass)
        end
      end
    end
  end
end
