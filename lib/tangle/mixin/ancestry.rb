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
        def ancestors
          result = Set[self] + parents.flat_map(&:ancestors)
          return result unless block_given?
          result.select(&:yield)
        end

        def ancestor?(other)
          other == self || parents.any? { |parent| parent.ancestor?(other) }
        end

        def descendants
          result = Set[self] + children.flat_map(&:descendants)
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
