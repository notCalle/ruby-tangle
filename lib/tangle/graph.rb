require 'tangle/mixin'
require 'tangle/mixin/connectedness'
require 'tangle/edge'
require 'tangle/graph_vertices'
require 'tangle/graph_edges'

module Tangle
  #
  # Base class for all kinds of graphs
  #
  class Graph
    include Tangle::GraphVertices
    include Tangle::GraphEdges
    include Tangle::Mixin::Initialize
    Edge = Tangle::Edge
    DEFAULT_MIXINS = Tangle::Mixin::Connectedness::MIXINS

    # Initialize a new graph, preloading it with vertices and edges
    #
    # Graph[+vertices+] => Graph
    # Graph[+vertices+, +edges+) => Graph
    #
    # When +vertices+ is a hash, it contains initialization kwargs as
    # values and vertex names as keys. When +vertices+ is an array of
    # initialization kwargs, the vertices will be be anonymous.
    #
    # +edges+ can contain an array of exactly two, either names of vertices
    # or vertices.
    #
    # Any kwarg supported by Graph.new is also allowed.
    #
    def self.[](vertices, edges = {}, **kwargs)
      graph = new(**kwargs)
      vertices.each { |vertex| graph.add_vertex(vertex) }
      edges.each { |from, to| graph.add_edge(from, to) }
      graph
    end

    # Initialize a new graph, optionally preloading it with vertices and edges
    #
    # Graph.new() => Graph
    # Graph.new(mixins: [MixinModule, ...], ...) => Graph
    #
    # +mixins+ is an array of modules that can be mixed into the various
    # classes that makes up a graph. Initialization of a Graph, Vertex or Edge
    # looks for submodules in each mixin, with the same name and extends
    # any created object. Defaults to [Tangle::Mixin::Connectedness].
    #
    # Any subclass of Graph should also subclass Edge to manage its unique
    # constraints.
    #
    def initialize(mixins: self.class::DEFAULT_MIXINS, **kwargs)
      initialize_vertices
      initialize_edges
      initialize_mixins(mixins: mixins, **kwargs)
    end

    # Return a subgraph, optionally filtered by a vertex selector block
    #
    # subgraph => Graph
    # subgraph { |vertex| ... } => Graph
    #
    # Unless a selector is provided, the subgraph contains the entire graph.
    #
    def subgraph(included = nil)
      included ||= vertices
      result = clone
      vertices.each do |vertex|
        result.remove_vertex(vertex) unless included.include?(vertex)
        next unless block_given?
        result.remove_vertex(vertex) unless yield(vertex)
      end
      result
    end

    def to_s
      "#<#{self.class}: #{vertices.count} vertices, #{edges.count} edges>"
    end
    alias inspect to_s

    private

    def callback(receiver, method, *args)
      receiver.send(method, *args) if receiver.respond_to?(method)
    end
  end
end
