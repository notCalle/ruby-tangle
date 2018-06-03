# frozen_string_literal: true

require 'set'

module Tangle
  # Vertex related methods in a graph
  module GraphVertices
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

    private

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
  end
end
