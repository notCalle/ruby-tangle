require 'tangle/directed/graph'
require 'tangle/directed/acyclic/edge'
require 'tangle/mixin/ancestry'

module Tangle
  module Directed
    module Acyclic
      #
      # A directed acyclic graph
      class Graph < Tangle::Directed::Graph
        Edge = Tangle::Directed::Acyclic::Edge
        DEFAULT_MIXINS = Tangle::Mixin::Ancestry::MIXINS
      end
    end
  end
end
