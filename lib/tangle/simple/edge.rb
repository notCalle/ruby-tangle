require 'tangle/edge'

module Tangle
  module Simple
    #
    # An edge in a simple graph, with no loops or multiedges
    #
    class Edge < Tangle::Edge
      private

      def validate_edge
        super
        raise LoopError unless @vertices.count == 2
        raise MultiEdgeError if @graph.edges.include? self
      end
    end
  end
end
