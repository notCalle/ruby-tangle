# frozen_string_literal: true

module Tangle
  module Directed
    module Acyclic
      # Implement a Partial Order for vertices in a DAG.
      class PartialOrder
        include Comparable

        # Wrap a set of vertices, or all vertices, in a graph
        # in a parial ordering, such that the elements in the
        # returned set are comparable by u <= v iff v is an
        # ancestor of u.
        def self.[](graph, *vertices)
          vertices = graph.vertices if vertices.empty?
          vertices.map { |vertex| new(graph, vertex) }
        end

        attr_reader :vertex

        protected

        attr_reader :graph

        def initialize(graph, vertex)
          @graph = graph
          @vertex = vertex
        end

        def <=>(other)
          raise GraphError unless graph == other.graph
          return 0 if vertex == other.vertex
          return -1 if graph.successor?(vertex, other.vertex)

          1
        end
      end
    end
  end
end
