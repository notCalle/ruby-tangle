require 'tangle/mixin/connectedness'

module Tangle
  module Mixin
    #
    # Mixin for adding ancestry features
    #
    module Ancestry
      #
      # Mixins for adding ancestry relations to a digraph
      #
      module Graph
        include Tangle::Mixin::Connectedness::Graph

        def ancestor_subgraph(vertex)
          subgraph { |other| vertex.ancestor?(other) }
        end

        def descendant_subgraph(vertex)
          subgraph { |other| vertex.descendant?(other) }
        end
      end

      #
      # Mixins for adding ancestry relations to vertices in a digraph
      #
      module Vertex
        include Tangle::Mixin::Connectedness::Vertex

        def parent_edges
          @graph.edges { |edge| edge.child?(self) }
        end

        def parents
          neighbours(parent_edges)
        end

        def parent?(other)
          @graph.edges.any? { |edge| edge.child?(self) && edge.parent?(other) }
        end

        def ancestor?(other)
          other == self || parents.any? { |parent| parent.ancestor?(other) }
        end

        def child_edges
          @graph.edges { |edge| edge.parent?(self) }
        end

        def children
          neighbours(child_edges)
        end

        def child?(other)
          @graph.edges.any? { |edge| edge.parent?(self) && edge.child?(other) }
        end

        def descendant?(other)
          other == self || children.any? { |child| child.descendant?(other) }
        end
      end
    end
  end
end
