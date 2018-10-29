# frozen_string_literal: true

require_relative '../graph'

module Tangle
  module Undirected
    module Simple
      #
      # A simple graph, without loops and multiple edges
      class Graph < Tangle::Undirected::Graph
        protected

        def insert_edge(edge)
          raise LoopError if edge.loop?
          raise MultiEdgeError if adjacent?(*edge.each_vertex)

          super
        end
      end
    end
  end
end
