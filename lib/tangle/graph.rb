require 'tangle/vertex'
require 'tangle/edge'

module Tangle
  #
  # Base class for all kinds of graphs
  #
  class Graph
    Edge = Tangle::Edge

    # Initialize a new graph, optionally preloading it with vertices and edges
    #
    # Graph.new() => Graph
    # Graph.new(vertices: +array_or_hash+) => Graph
    # Graph.new(vertices: +array_or_hash+, edges: +array_or_hash+) => Graph
    #
    # When +array_or_hash+ is a hash, it contains the objects as values and
    # their names as keys. When +array_or_hash+ is an array the objects will
    # get assigned unique names (within the graph).
    #
    # +vertices+ can contain anything, and the Vertex object that is created
    # will delegate all missing methods to its content.
    #
    # +edges+ can contain an array of exactly two, either names of vertices
    # or vertices.
    #
    # Any subclass of Graph should also subclass Edge to manage its unique
    # constraints.
    #
    def initialize(vertices: nil, edges: nil)
      @vertices_by_id = {}
      @vertices_by_name = {}
      @edges ||= []

      initialize_vertices(vertices)
      initialize_edges(edges)
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
    #   contents: delegate object for missing methods
    #
    def add_vertex(**kvargs)
      insert_vertex(Vertex.new(graph: self, **kvargs))
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

      dup_vertices_into(graph, &selector)
      dup_edges_into(graph)

      graph
    end
    alias dup subgraph

    # Get the largest connected subgraph for a vertex.
    # Also aliased as :component and :connected_component
    #
    # connected_subgraph(vertex) => Graph
    #
    def connected_subgraph(vertex)
      subgraph { |other| vertex.connected?(other) }
    end
    alias component connected_subgraph
    alias connected_component connected_subgraph

    # Get the largest subgraph that is not connected to a vertex, or what's
    # left after removing the connected subgraph.
    #
    def disconnected_subgraph(vertex)
      subgraph { |other| !vertex.connected?(other) }
    end

    # A graph is connected if all vertices are connected to all vertices
    # An empty graph is disconnected.
    #
    def connected?
      return false if vertices.empty?

      vertices.combination(2).all? do |pair|
        this, that = pair.to_a
        this.connected?(that)
      end
    end

    # A graph is disconnected if any vertex is not connected to all other.
    # An empty graph is disconnected.
    #
    def disconnected?
      !connected?
    end

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

    def initialize_vertices(vertices)
      return if vertices.nil?

      case vertices
      when Hash
        initialize_named_vertices(vertices)
      else
        initialize_anonymous_vertices(vertices)
      end
    end

    def initialize_named_vertices(vertices)
      vertices.each do |name, delegate|
        add_vertex(name: name, delegate: delegate)
      end
    end

    def initialize_anonymous_vertices(vertices)
      vertices.each do |delegate|
        add_vertex(delegate: delegate)
      end
    end

    def initialize_edges(edges)
      return if edges.nil?

      edges.each do |vertices|
        add_edge(*vertices)
      end
    end

    def dup_vertices_into(graph, &selector)
      vertices(&selector).each do |vertex|
        graph.insert_vertex(vertex.dup_into(graph))
      end
    end

    def dup_edges_into(graph)
      edges.each do |edge|
        new_edge = edge.dup_into(graph)
        graph.insert_edge(new_edge) unless new_edge.nil?
      end
    end
  end
end
