module Tangle
  module Mixin
    #
    # Mixin for adding parent/child relation features
    #
    module Relations
      MIXINS = [Tangle::Mixin::Relations].freeze
      #
      # Mixins for adding relation relations to vertices in a digraph
      #
      module Vertex
        def parent_edges
          @graph.edges(vertex: self) { |edge| edge.child?(self) }
        end

        def parents
          neighbours(parent_edges)
        end

        def parent?(other)
          @graph.edges.any? { |edge| edge.child?(self) && edge.parent?(other) }
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
      end
    end
  end
end
