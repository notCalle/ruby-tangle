# frozen_string_literal: true

require 'tangle/currify'
require 'tangle/mixin'
require 'tangle/edge'

module Tangle
  #
  # Base class for all kinds of graphs
  #
  class Graph
    include Tangle::Currify
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

    # Two vertices are adjacent if there is an edge between them
    def adjacent?(vertex, other)
      edges(vertex).any? { |edge| edge[vertex] == other }
    end

    # Return the set of adjacent vertices
    def adjacent(vertex)
      Set.new(edges(vertex).map { |edge| edge.walk(vertex) })
    end

    # Get the largest connected subgraph for a vertex.
    # Also aliased as :component and :connected_component
    #
    # connected_subgraph(vertex) => Graph
    #
    def connected_subgraph(vertex)
      subgraph { |other| connected_vertices?(vertex, other) }
    end
    alias component connected_subgraph
    alias connected_component connected_subgraph

    # Get the largest subgraph that is not connected to a vertex, or what's
    # left after removing the connected subgraph.
    #
    def disconnected_subgraph(vertex)
      subgraph { |other| !connected_vertices?(vertex, other) }
    end

    # A graph is connected if all vertices are connected to all vertices
    # An empty graph is disconnected.
    #
    def connected?(*tested_vertices)
      tested_vertices = vertices if tested_vertices.empty?
      return false if tested_vertices.empty?

      tested_vertices.combination(2).all? do |pair|
        this, that = pair.to_a
        reachable(this).any? { |other| other == that }
      end
    end

    # A graph is disconnected if any vertex is not connected to all other.
    # An empty graph is disconnected.
    #
    def disconnected?(*tested_vertices)
      !connected?(*tested_vertices)
    end

    # Return a breadth-first Enumerator for all reachable vertices,
    # by transitive adjacency.
    def reachable(start_vertex)
      vertex_enumerator(start_vertex, :adjacent)
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

    def select_vertices!(selected = nil)
      vertices.each do |vertex|
        delete_vertex(vertex) if block_given? && !yield(vertex)
        next if selected.nil?
        delete_vertex(vertex) unless selected.any? { |vtx| vtx.eql?(vertex) }
      end
    end

    def insert_vertex(vertex, name = nil)
      @vertices[vertex] = Set[]
      @vertices_by_name[name] = vertex unless name.nil?
    end

    def delete_vertex(vertex)
      @vertices[vertex].each do |edge|
        delete_edge(edge) if edge.include?(vertex)
      end
      @vertices.delete(vertex)
      @vertices_by_name.delete_if { |_, vtx| vtx.eql?(vertex) }
    end

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

    # Initialize vertex related attributes
    def initialize_vertices
      @vertices = {}
      @vertices_by_name = {}
    end

    # Yield each reachable vertex to a block, breadth first
    def each_vertex_breadth_first(start_vertex, walk_method)
      remaining = [start_vertex]
      remaining.each_with_object([]) do |vertex, history|
        history << vertex
        yield vertex
        send(walk_method, vertex).each do |other|
          remaining << other unless history.include?(other)
        end
      end
    end

    def vertex_enumerator(start_vertex, walk_method)
      Enumerator.new do |yielder|
        each_vertex_breadth_first(start_vertex, walk_method) do |vertex|
          yielder << vertex
        end
      end
    end

    def initialize_edges
      @edges = Set[]
    end
  end
end
