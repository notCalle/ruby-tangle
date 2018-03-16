require 'tangle/mixin'
require 'tangle/vertex'
require 'tangle/edge'

module Tangle
  #
  # Base class for all kinds of graphs
  #
  class Graph
    include Tangle::Mixin::Initialize
    Edge = Tangle::Edge
    DEFAULT_MIXINS = [Tangle::Mixin::Connectedness].freeze

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
      graph.add_vertices(vertices)
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
      initialize_mixins(mixins, **kwargs)
      initialize_vertices
      initialize_edges
    end

    # Get all edges.
    #
    # edges => Array
    #
    def edges(&selector)
      if block_given?
        @edges.select(&selector)
      else
        @edges.to_a
      end
    end

    # Add a new edge to the graph
    #
    # add_edge(vtx1, vtx2, ...) => Edge
    #
    def add_edge(*vertices, **kvargs)
      vertices = vertices.map { |v| get_vertex(v) }
      insert_edge(self.class::Edge.new(*vertices, graph: self, **kvargs))
    end

    # Get all vertices.
    #
    # vertices => Array
    #
    def vertices
      if block_given?
        @vertices_by_id.select { |_, vertex| yield(vertex) }
      else
        @vertices_by_id
      end.values
    end

    # Add a new vertex to the graph
    #
    # add_vertex(...) => Vertex
    #
    # Optional named arguments:
    #   name: unique name or label for vertex
    #
    def add_vertex(**kvargs)
      insert_vertex(Vertex.new(graph: self, **kvargs))
    end

    def add_vertices(vertices)
      case vertices
      when Array
        vertices.each do |kwargs|
          add_vertex(**kwargs)
        end
      when Hash
        vertices.each do |name, kwargs|
          add_vertex(name: name, **kwargs)
        end
      end
    end

    def get_vertex(name_or_vertex)
      case name_or_vertex
      when Vertex
        name_or_vertex
      else
        @vertices_by_name[name_or_vertex] ||
          @vertices_by_id.fetch(name_or_vertex)
      end
    end

    # Return a subgraph, optionally filtered by a vertex selector block
    #
    # subgraph => Graph
    # subgraph { |vertex| ... } => Graph
    #
    # Unless a selector is provided, the subgraph contains the entire graph.
    #
    def subgraph(&selector)
      graph = self.class.new

      clone_vertices_into(graph, &selector)
      clone_edges_into(graph)

      graph
    end
    alias clone subgraph

    attr_reader :mixins

    protected

    # Insert a prepared vertex into the graph
    #
    def insert_vertex(vertex)
      raise ArgumentError unless vertex.graph.eql?(self)

      @vertices_by_name[vertex.name] = vertex unless vertex.name.nil?
      @vertices_by_id[vertex.vertex_id] = vertex
    end

    # Insert a prepared edge into the graph
    #
    def insert_edge(edge)
      raise ArgumentError unless edge.graph.eql?(self)

      @edges << edge
      edge
    end

    private

    def initialize_vertices
      @vertices_by_id = {}
      @vertices_by_name = {}
    end

    def initialize_edges
      @edges = []
    end

    def clone_vertices_into(graph, &selector)
      vertices(&selector).each do |vertex|
        graph.insert_vertex(vertex.clone_into(graph))
      end
    end

    def clone_edges_into(graph)
      edges.each do |edge|
        new_edge = edge.clone_into(graph)
        graph.insert_edge(new_edge) unless new_edge.nil?
      end
    end
  end
end
