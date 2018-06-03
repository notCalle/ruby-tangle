# frozen_string_literal: true

module Tangle
  #
  # Private methods of BaseGraph
  #
  module BaseGraphPrivate
    private

    def callback(receiver, method, *args)
      receiver.send(method, *args) if receiver.respond_to?(method)
    end

    # Initialize vertex related attributes
    def initialize_vertices
      @vertices = {}
      @vertices_by_name = {}
    end

    def initialize_edges
      @edges = Set[]
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
