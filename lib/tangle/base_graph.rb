# frozen_string_literal: true

require_relative 'currify'
require_relative 'mixin'
require_relative 'base_graph_protected'
require_relative 'base_graph_private'

module Tangle
  #
  # Abstract base class for (un)directed graphs
  #
  class BaseGraph
    include Tangle::Currify
    include Tangle::Mixin::Initialize
    include Tangle::BaseGraphProtected
    include Tangle::BaseGraphPrivate

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

    # Fetch a vertex by its name
    def fetch(name)
      @vertices_by_name.fetch(name)
    end

    # Return a named vertex
    def [](name)
      @vertices_by_name[name]
    end

    # Return all vertices in the graph
    def vertices
      @vertices.keys
    end

    # Select vertices in the graph
    def select(&selector)
      @vertices.each_key.select(&selector)
    end

    # Add a vertex into the graph
    #
    # If a name: is given, or the vertex responds to :name,
    # it will be registered by name in the graph
    def add_vertex(vertex, name: nil)
      name ||= callback(vertex, :name)
      insert_vertex(vertex, name)
      define_currified_methods(vertex, :vertex) if @currify
      callback(vertex, :added_to_graph, self)
      self
    end
    alias << add_vertex

    # Remove a vertex from the graph
    def remove_vertex(vertex)
      @vertices[vertex].each do |edge|
        remove_edge(edge) if edge.include?(vertex)
      end
      delete_vertex(vertex)
      callback(vertex, :removed_from_graph, self)
    end

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
      edge = new_edge(*vertices, mixins: @mixins, **kvargs)
      insert_edge(edge)
      vertices.each { |vertex| callback(vertex, :edge_added, edge) }
      edge
    end

    # Remove an edge from the graph
    def remove_edge(edge)
      delete_edge(edge)
      edge.each_vertex { |vertex| callback(vertex, :edge_removed, edge) }
    end
  end
end
