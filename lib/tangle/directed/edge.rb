require 'tangle/edge'

module Tangle
  module Directed
    #
    # An edge in a directed graph
    #
    class Edge < Tangle::Edge
      def initialize(vertex1, vertex2 = vertex1, graph: nil)
        @child, @parent = @vertices = [vertex1, vertex2]
        super
      end

      def parent?(vertex)
        @parent == vertex
      end

      def parent(_vertex)
        @parent
      end

      def child?(vertex)
        @child == vertex
      end

      def child(_vertex)
        @child
      end
    end
  end
end
