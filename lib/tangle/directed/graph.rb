require 'tangle/graph'
require 'tangle/directed/edge'
require 'tangle/mixin/ancestry'

module Tangle
  module Directed
    #
    # A directed graph
    class Graph < Tangle::Graph
      Edge = Tangle::Directed::Edge
      DEFAULT_MIXINS = Tangle::Mixin::Ancestry::MIXINS
    end
  end
end
