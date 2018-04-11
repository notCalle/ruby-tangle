require 'tangle/mixin/relations'
require 'set'

module Tangle
  module Mixin
    #
    # Mixin for adding ancestry features
    #
    module Ancestry
      MIXINS = (Tangle::Mixin::Relations::MIXINS +
                [Tangle::Mixin::Ancestry]).freeze
      #
      # Mixins for adding ancestry relations to a digraph
      #
      module Graph
        def ancestor_subgraph(vertex, &selector)
          vertex = get_vertex(vertex) unless vertex.is_a? Vertex
          clone.with_vertices(vertex.ancestors(&selector)).with_edges(edges)
        end

        def descendant_subgraph(vertex, &selector)
          vertex = get_vertex(vertex) unless vertex.is_a? Vertex
          clone.with_vertices(vertex.descendants(&selector)).with_edges(edges)
        end
      end

      #
      # Mixins for adding ancestry relations to vertices in a digraph
      #
      module Vertex
        def parent_edges
          @graph.edges(vertex: self) { |edge| edge.child?(self) }
        end

        def parents
          neighbours(parent_edges)
        end

        def ancestors
          result = [self] + parents.flat_map(&:ancestors)
          return result unless block_given?
          result.select(&:yield)
        end

        def parent?(other)
          @graph.edges.any? { |edge| edge.child?(self) && edge.parent?(other) }
        end

        def ancestor?(other)
          other == self || parents.any? { |parent| parent.ancestor?(other) }
        end

        def child_edges
          @graph.edges(vertex: self) { |edge| edge.parent?(self) }
        end

        def children
          neighbours(child_edges)
        end

        def child?(other)
          @graph.edges.any? { |edge| edge.parent?(self) && edge.child?(other) }
        end

        def descendants
          result = [self] + children.flat_map(&:descendants)
          return result unless block_given?
          result.select(&:yield)
        end

        def descendant?(other)
          other == self || children.any? { |child| child.descendant?(other) }
        end
      end
    end
  end
end
