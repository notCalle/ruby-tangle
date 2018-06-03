# frozen_string_literal: true

require 'tangle/currify'
require 'tangle/mixin'
require 'tangle/edge'
require 'tangle/graph_vertices'

module Tangle
  #
  # Base class for all kinds of graphs
  #
  class Graph
    include Tangle::Currify
    include Tangle::GraphVertices
    include Tangle::Mixin::Initialize
    Edge = Tangle::Edge

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
    def initialize(currify: false, mixins: [], **kwargs)
      @currify = currify
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
    def subgraph(included = nil, &selector)
      result = clone
      result.select_vertices!(included) unless included.nil?
      result.select_vertices!(&selector) if block_given?
      result
    end

    def to_s
      "#<#{self.class}: #{vertices.count} vertices, #{edges.count} edges>"
    end
    alias inspect to_s

    # Get all edges.
    #
    # edges => Array
    #
    def edges(vertex = nil)
      return @edges if vertex.nil?
      @vertices.fetch(vertex)
    end
    currify :vertex, :edges

    # Add a new edge to the graph
    #
    # add_edge(vtx1, vtx2, ...) => Edge
    #
    def add_edge(*vertices, **kvargs)
      edge = self.class::Edge.new(*vertices, mixins: @mixins, **kvargs)
      insert_edge(edge)
      vertices.each { |vertex| callback(vertex, :edge_added, edge) }
      edge
    end

    # Remove an edge from the graph
    def remove_edge(edge)
      delete_edge(edge)
      edge.each_vertex { |vertex| callback(vertex, :edge_removed, edge) }
    end

    protected

    # Insert a prepared edge into the graph
    #
    def insert_edge(edge)
      @edges << edge
      edge.each_vertex { |vertex| @vertices.fetch(vertex) << edge }
    end

    def delete_edge(edge)
      edge.each_vertex { |vertex| @vertices.fetch(vertex).delete(edge) }
      @edges.delete(edge)
    end

    private

    def callback(receiver, method, *args)
      receiver.send(method, *args) if receiver.respond_to?(method)
    end

    def initialize_edges
      @edges = Set[]
    end
  end
end
