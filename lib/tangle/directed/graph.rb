require 'tangle/graph'
require 'tangle/directed/edge'

module Tangle
  module Directed
    #
    # A directed graph
    class Graph < Tangle::Graph
      Edge = Tangle::Directed::Edge
      DEFAULT_MIXINS = [Tangle::Mixin::Ancestry].freeze
    end
  end
end
