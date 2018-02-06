module Tangle
  module Mixin
    #
    # Mixins for adding connectedness features
    #
    module Connectedness
      #
      # Mixin for adding connectedness to a graph
      #
      module Graph
        # Get the largest connected subgraph for a vertex.
        # Also aliased as :component and :connected_component
        #
        # connected_subgraph(vertex) => Graph
        #
        def connected_subgraph(vertex)
          subgraph { |other| vertex.connected?(other) }
        end
        alias component connected_subgraph
        alias connected_component connected_subgraph

        # Get the largest subgraph that is not connected to a vertex, or what's
        # left after removing the connected subgraph.
        #
        def disconnected_subgraph(vertex)
          subgraph { |other| !vertex.connected?(other) }
        end

        # A graph is connected if all vertices are connected to all vertices
        # An empty graph is disconnected.
        #
        def connected?
          return false if vertices.empty?

          vertices.combination(2).all? do |pair|
            this, that = pair.to_a
            this.connected?(that)
          end
        end

        # A graph is disconnected if any vertex is not connected to all other.
        # An empty graph is disconnected.
        #
        def disconnected?
          !connected?
        end
      end

      #
      # Mixin for adding connectedness to a vertex
      #
      module Vertex
        # Two vertices are connected if there is a path between them,
        # and a vertex is connected to itself.
        #
        def connected?(other)
          raise GraphError unless @graph == other.graph
          return true if self == other

          connected_excluding?(other, Set[self])
        end

        protected

        def connected_excluding?(other, history)
          return true if adjacent?(other)

          (neighbours - history).any? do |vertex|
            vertex.connected_excluding?(other, history << self)
          end
        end
      end
    end
  end
end
