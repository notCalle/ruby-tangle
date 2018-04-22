require 'tangle/graph'

module Tangle
  module Simple
    #
    # A simple graph, without loops and multiple edges
    class Graph < Tangle::Graph
      protected

      def insert_edge(edge)
        raise LoopError if edge.loop?
        raise MultiEdgeError if adjacent?(*edge.each_vertex)
        super
      end
    end
  end
end
