require 'tangle/graph'
require 'tangle/directed/edge'
require 'tangle/mixin/relations'

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
