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
        # THe ancestor_subgraph simply contains all the ancestors,
        # and the vertex itself
        def ancestor_subgraph(vertex, &selector)
          vertex = get_vertex(vertex) unless vertex.is_a? Vertex
          clone.with_vertices(vertex.ancestors(&selector)).with_edges(edges)
        end

        # The descendant_subgraph contains all the descendats,
        # and the vertex itself
        def descendant_subgraph(vertex, &selector)
          vertex = get_vertex(vertex) unless vertex.is_a? Vertex
          clone.with_vertices(vertex.descendants(&selector)).with_edges(edges)
        end

        # The dependant_subgraph contains all the descendants,
        # and all their ancestors, because they depend on them.
        def dependant_subgraph(vertex, &selector)
          vertex = get_vertex(vertex) unless vertex.is_a? Vertex
          dependant_vertices = []

          vertex.descendants(&selector).each do |descendant|
            dependant_vertices += descendant.ancestors
          end

          clone.with_vertices(dependant_vertices.uniq).with_edges(edges)
        end
      end

      #
      # Mixins for adding ancestry relations to vertices in a digraph
      #
      module Vertex
        def ancestors
          result = [self] + parents.flat_map(&:ancestors).uniq
          return result unless block_given?
          result.select(&:yield)
        end

        def ancestor?(other)
          other == self || parents.any? { |parent| parent.ancestor?(other) }
        end

        def descendants
          result = [self] + children.flat_map(&:descendants).uniq
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
