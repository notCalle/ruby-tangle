require 'tangle/directed/graph'

module Tangle
  module Directed
    module Acyclic
      #
      # A directed acyclic graph
      class Graph < Tangle::Directed::Graph
        protected

        def insert_edge(edge)
          raise CyclicError if ancestor?(edge.parent, edge.child) ||
                               descendant?(edge.child, edge.parent)
          super
        end
      end
    end
  end
end
