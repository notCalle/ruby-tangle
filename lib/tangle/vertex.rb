require 'delegate'
require 'pp'

module Tangle
  #
  # A named vertex in a graph
  #
  class Vertex < SimpleDelegator
    include PP::ObjectMixin

    # Create a new vertex
    #
    # Vertex.new(...) => Vertex
    #
    # Named arguments:
    #   graph: a Graph or nil for an orphaned vertex
    #   name: anything that's hashable and unique within the graph
    #   delegate: delegate object for missing methods
    #
    def initialize(graph: nil,
                   name: nil,
                   delegate: nil,
                   vertex_id: object_id)
      super(delegate) unless delegate.nil?

      @graph = graph
      @name = name
      @delegate = delegate
      @vertex_id = vertex_id
    end

    # Duplicate a vertex in a new graph, keeping all other contained attributes
    # End users should probably use Graph#subgrap instead.
    #
    # dup_into(new_graph) => Vertex
    #
    # Raises an ArgumentError if graph would remain the same.
    #
    def dup_into(graph)
      raise ArgumentError if graph == @graph

      Vertex.new(
        graph:     graph,
        name:      @name,
        delegate:  @delegate,
        vertex_id: @vertex_id
      )
    end

    # Return all edges that touch this vertex
    #
    def edges
      return [] if @graph.nil?

      @graph.edges { |edge| edge.include? self }
    end

    # Return the set of adjacent vertices
    #
    def neighbours
      Set.new(edges.map { |edge| edge.walk(self) })
    end

    # If two vertices have the same vertex_id, they have the same value
    #
    def ==(other)
      @vertex_id == other.vertex_id
    end

    # If two vertices have the same vertex_id, they have the same value
    #
    def !=(other)
      @vertex_id != other.vertex_id
    end

    # If two vertices have the same object_id, they are identical
    #
    def eql?(other)
      @object_id == other.object_id
    end

    # Two vertices are adjacent if there is an edge between them
    #
    def adjacent?(other)
      raise GraphError unless @graph == other.graph
      edges.any? { |edge| edge.walk(self) == other }
    end

    attr_reader :graph
    attr_reader :name
    attr_reader :delegate
    attr_reader :vertex_id
  end
end
