require 'set'

module Tangle
  # Edge related methods in a graph
  module GraphEdges
    # Get all edges.
    #
    # edges => Array
    #
    def edges(vertex = nil)
      return @edges if vertex.nil?
      vertex = fetch_vertex(vertex) unless vertex.is_a? Vertex
      @edges_by_vertex.fetch(vertex)
    end

    # Add a new edge to the graph
    #
    # add_edge(vtx1, vtx2, ...) => Edge
    #
    def add_edge(*vertices, **kvargs)
      vertices = get_vertices(vertices)
      insert_edge(self.class::Edge.new(*vertices, **kvargs))
    end

    # Remove an edge from the graph
    def remove_edge(edge)
      edge.each_vertex do |vertex|
        @edges_by_vertex[vertex].delete(edge)
      end
      @edges.delete(edge)
    end

    protected

    # Insert a prepared edge into the graph
    #
    def insert_edge(edge)
      @edges << edge
      edge.each_vertex do |vertex|
        @edges_by_vertex[vertex] << edge
      end
      edge
    end

    private

    def initialize_edges
      @edges = Set[]
    end
  end
end
