module Tangle
  module Mixin
    #
    # Mixin for adding ancestry features
    #
    module Ancestry
      MIXINS = [Tangle::Mixin::Ancestry].freeze
      #
      # Mixins for adding ancestry relations to a digraph
      #
      module Graph
        # Return the parent edges for +vertex+
        def parent_edges(vertex)
          vertex = get_vertex(vertex)
          edges(vertex).select { |edge| edge.child?(vertex) }
        end

        # Return the parents of +vertex+
        def parents(vertex)
          vertex = get_vertex(vertex)
          Set.new(parent_edges(vertex).map(&:parent))
        end

        # Is +other+ a parent of +vertex+?
        def parent?(vertex, other)
          vertex, other = get_vertices(vertex, other)
          parent_edges(vertex).any? { |edge| edge.parent?(other) }
        end

        # Return the child edges for +vertex+
        def child_edges(vertex)
          vertex = get_vertex(vertex)
          edges(vertex).select { |edge| edge.parent?(vertex) }
        end

        # Return the children of +vertex+
        def children(vertex)
          vertex = get_vertex(vertex)
          Set.new(child_edges(vertex).map(&:child))
        end

        # Is +other+ a child of +vertex+?
        def child?(vertex, other)
          vertex, other = get_vertices(vertex, other)
          child_edges(vertex).any? { |edge| edge.child?(other) }
        end

        # THe ancestor_subgraph simply contains all the ancestors,
        # and the vertex itself
        def ancestor_subgraph(vertex, &selector)
          vertex = get_vertex(vertex)
          subgraph(ancestors(vertex), &selector)
        end

        # The descendant_subgraph contains all the descendats,
        # and the vertex itself
        def descendant_subgraph(vertex, &selector)
          vertex = get_vertex(vertex)
          subgraph(descendants(vertex), &selector)
        end

        # The dependant_subgraph contains all the descendants,
        # and all their ancestors, because they depend on them.
        def dependant_subgraph(vertex, &selector)
          vertex = get_vertex(vertex)
          dependants = Set[]

          descendants(vertex).select(&selector).each do |descendant|
            dependants << ancestors(descendant).select(&selector)
          end
          subgraph(dependants)
        end

        # Return a breadth first enumerator for all reachable vertices,
        # by transitive ancestry
        def ancestors(vertex)
          vertex = get_vertex(vertex)
          vertex_enumerator(vertex, :parents)
        end

        # Is +other+ an ancestor of +vertex+?
        def ancestor?(vertex, other)
          vertex, other = get_vertices(vertex, other)
          ancestors(vertex).include?(other)
        end

        # Return a breadth first enumerator for all reachable vertices,
        # by transitive descendancy
        def descendants(vertex)
          vertex = get_vertex(vertex)
          vertex_enumerator(vertex, :children)
        end

        # Is +other+ a descendant of +vertex+?
        def descendant?(vertex, other)
          vertex, other = get_vertices(vertex, other)
          descendants(vertex).include?(other)
        end
      end
    end
  end
end
