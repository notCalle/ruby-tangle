require 'tangle/directed/edge'

module Tangle
  module Directed
    module Acyclic
      #
      # An edge in a directed acyclic graph
      #
      class Edge < Tangle::Directed::Edge
        private

        def validate_edge
          super
          raise CyclicError if @parent.ancestor?(@child) ||
                               @child.descendant?(@parent)
        end
      end
    end
  end
end
