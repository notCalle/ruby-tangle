require 'tangle/edge'

module Tangle
  module Directed
    #
    # An edge in a directed graph
    #
    class Edge < Tangle::Edge
      def parent?(vertex)
        @parent == vertex
      end

      def parent(_vertex = nil)
        @parent
      end

      def child?(vertex)
        @child == vertex
      end

      def child(_vertex = nil)
        @child
      end

      protected

      def with_vertices(vertex1, vertex2 = vertex1)
        @child, @parent = @vertices = [vertex1, vertex2]
        self
      end
    end
  end
end
