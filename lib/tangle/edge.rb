require 'tangle/errors'

module Tangle
  #
  # An edge in a graph, connecting two vertices
  #
  class Edge
    extend Forwardable
    include Tangle::Mixin::Initialize

    # Create a new edge between vertices
    #
    # Edge.new(vtx1) => Edge (loop)
    # Edge.new(vtx1, vtx2) => Edge
    #
    # End users should probably use Graph#add_edge instead.
    #
    def initialize(vertex1, vertex2 = vertex1, graph: nil)
      @vertices = Set[vertex1, vertex2]
      @graph = graph

      initialize_mixins

      validate_edge
    end

    # Follow the edge from a vertex to the other end
    #
    # walk(vertex) => Vertex
    #
    def walk(from_vertex)
      raise RuntimeError unless @vertices.include?(from_vertex)
      @vertices.find { |other| other != from_vertex } || from_vertex
    end

    # Duplicate an edge into another graph, replacing original vertices with
    # their already prepared duplicates in the other graph. Returns nil if any
    # of the vertices does not exist in the other graph.
    # End users should probably use Graph#subgraph instead.
    #
    # dup_into(graph) => Edge or nil
    #
    # Raises an ArgumentError if graph would remain the same.
    #
    def dup_into(graph)
      raise ArgumentError if graph == @graph

      vertices = @vertices.map do |vertex|
        graph.get_vertex(vertex.vertex_id)
      end
      self.class.new(*vertices, graph: graph)
    rescue KeyError
      nil
    end

    def inspect
      "#<#{self.class}: #{@vertices}>"
    end

    def eql?(other)
      @graph == other.graph && @vertices == other.vertices
    end
    alias == eql?
    alias === eql?
    alias equal? eql?

    attr_reader :name
    attr_reader :graph
    attr_reader :vertices

    def_delegators :@vertices, :include?, :hash

    private

    def validate_edge
      raise GraphError unless @vertices.all? { |vertex| vertex.graph == @graph }
    end
  end
end
