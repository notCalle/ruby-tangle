require 'tangle/directed/graph'
require 'tangle/directed/acyclic/partial_order'

module Tangle
  module Directed
    module Acyclic
      # A directed acyclic graph
      class Graph < Tangle::Directed::Graph
        # Return a topological ordering of a set of vertices, or all
        # vertices in the graph.
        def topological_ordering(*vertices)
          vertices = if vertices.empty?
                       self.vertices
                     else
                       get_vertices(*vertices) unless vertices.empty?
                     end
          PartialOrder[self, vertices].sort!.map(&:vertex)
        end

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
