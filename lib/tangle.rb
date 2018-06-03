# frozen_string_literal: true

require 'tangle/version'
require 'tangle/errors'
require 'tangle/undirected/graph'
require 'tangle/undirected/simple/graph'
require 'tangle/directed/graph'
require 'tangle/directed/acyclic/graph'

# Tangle manages various types of graphs
#
# Tangle::MultiGraph.new
# => Undirected graph without edge constraints
#
# Tangle::SimpleGraph.new
# => Undirected graph with single edges between vertices, and no loops
#
# Tangle::DiGraph.new
# => Directed graph without edge constraints
#
# Tangle::DAG.new
# => Directed graph with no edge cycles
#
module Tangle
  Graph = Tangle::Undirected::Graph
  MultiGraph = Tangle::Undirected::Graph
  SimpleGraph = Tangle::Undirected::Simple::Graph
  DiGraph = Tangle::Directed::Graph
  DAG = Tangle::Directed::Acyclic::Graph
end
