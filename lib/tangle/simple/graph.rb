require 'tangle/graph'
require 'tangle/simple/edge'

module Tangle
  module Simple
    #
    # A simple graph, without loops and multiple edges
    class Graph < Tangle::Graph
      Edge = Tangle::Simple::Edge

      def initialize(**kwargs)
        @edges ||= Set[]
        super
      end
    end
  end
end
