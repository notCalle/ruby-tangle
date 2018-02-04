require 'tangle/version'
require 'tangle/errors'
require 'tangle/graph'
require 'tangle/simple/graph'

# Tangle manages various types of graphs
#
# Tangle::MultiGraph.new
# => Undirected graph without edge constraints
#
# Tangle::SimpleGraph.new
# => Undirected graph with single edges between vertices, and no loops
#
module Tangle
  MultiGraph = Tangle::Graph
  SimpleGraph = Tangle::Simple::Graph
end
