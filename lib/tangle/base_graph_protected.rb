# frozen_string_literal: true

module Tangle
  #
  # Protected methods of BaseGraph
  #
  module BaseGraphProtected
    protected

    def copy_vertices_and_edges(from)
      @vertices = from.instance_variable_get(:@vertices).dup
      @vertices_by_name = from.instance_variable_get(:@vertices_by_name).dup
      @edges = from.instance_variable_get(:@edges).dup
    end

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
  end
end
