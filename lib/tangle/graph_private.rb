module Tangle
  #
  # The private bits of Graph
  #
  module GraphPrivate
    private

    def initialize_vertices
      @vertices_by_id = {}
      @vertices_by_name = {}
      @edges_by_vertex = {}
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
