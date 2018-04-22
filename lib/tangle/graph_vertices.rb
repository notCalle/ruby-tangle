require 'set'

module Tangle
  # Vertex related methods in a graph
  module GraphVertices
    attr_reader :vertices

    # Prepare a new vertex, and insert into the graph
    #
    # add_vertex(...) => Vertex
    #
    # See +Vertex.new+ for valid kwargs
    def add_vertex(**kwargs)
      insert_vertex(Vertex.new(**kwargs))
    end

    # Add multiple vertices
    def add_vertices(vertices)
      case vertices
      when Hash
        vertices.each { |name, kwargs| add_vertex(name: name, **kwargs) }
      else
        vertices.each { |kwargs| add_vertex(**kwargs) }
      end
    end

    def fetch_vertex(name)
      @vertices_by_name.fetch(name)
    end

    def get_vertex(name)
      return name if name.is_a? Vertex
      fetch_vertex(name)
    end

    def get_vertices(*names)
      names.flatten.map { |name| get_vertex(name) }
    end

    # Remove a vertex from the graph
    def remove_vertex(vertex)
      vertex = get_vertex(vertex)
      @edges_by_vertex[vertex].each do |edge|
        remove_edge(edge) if edge.include?(vertex)
      end
      @edges_by_vertex.delete(vertex)
      @vertices_by_name.delete(vertex.name) unless vertex.name.nil?
      @vertices.delete(vertex)
    end

    protected

    # Insert a vertex into the graph
    def insert_vertex(vertex)
      @vertices << vertex
      @vertices_by_name[vertex.name] = vertex unless vertex.name.nil?
      @edges_by_vertex[vertex] = Set[]
      vertex
    end

    private

    # Initialize vertex related attributes
    def initialize_vertices
      @vertices = Set[]
      @vertices_by_name = {}
      @edges_by_vertex = {}
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
