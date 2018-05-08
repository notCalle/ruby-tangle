require 'set'

module Tangle
  # Vertex related methods in a graph
  module GraphVertices
    # Return all vertices in the graph
    def vertices
      @vertices.keys
    end

    # Add a vertex into the graph
    def add_vertex(vertex)
      @vertices[vertex] = Set[]
      self
    end
    alias << add_vertex

    # Remove a vertex from the graph
    def remove_vertex(vertex)
      @vertices[vertex].each do |edge|
        remove_edge(edge) if edge.include?(vertex)
      end
      @vertices.delete(vertex)
    end

    private

    # Initialize vertex related attributes
    def initialize_vertices
      @vertices = {}
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
  end
end