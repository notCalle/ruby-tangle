module Tangle
  #
  # The protected bits of Graph
  #
  module GraphProtected
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

    def with_vertices(vertices = [])
      initialize_vertices

      vertices.each do |vertex|
        insert_vertex(vertex.clone_into(self))
      end
      self
    end

    def with_edges(edges = [])
      initialize_edges

      edges.each do |edge|
        new_edge = edge.clone_into(self)
        insert_edge(new_edge) unless new_edge.nil?
      end
      self
    end
  end
end
