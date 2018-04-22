require 'tangle/edge'

module Tangle
  module Directed
    #
    # An edge in a directed graph
    #
    class Edge < Tangle::Edge
      attr_reader :parent, :child

      def parent?(vertex)
        @parent == vertex
      end

      def child?(vertex)
        @child == vertex
      end

      def each_vertex(&block)
        [@child, @parent].each(&block)
      end

      def to_s
        "{#{@child}=>#{@parent}}"
      end

      private

      def initialize_vertices(child, parent = child)
        super
        @child = child
        @parent = parent
        @vertices = { child => parent }
      end
    end
  end
end
