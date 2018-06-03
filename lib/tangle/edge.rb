# frozen_string_literal: true

require 'forwardable'
require_relative 'mixin'

module Tangle
  #
  # An edge in an undirected graph, connecting two vertices
  #
  class Edge
    include Tangle::Mixin::Initialize

    attr_reader :name

    # Create a new edge between vertices
    #
    # Edge.new(vtx1) => Edge (loop)
    # Edge.new(vtx1, vtx2) => Edge
    #
    # End users should probably use Graph#add_edge instead.
    #
    def initialize(vertex1, vertex2 = vertex1, name: nil, **kwargs)
      @name = name
      initialize_vertices(vertex1, vertex2)
      initialize_mixins(**kwargs)
    end

    def [](from_vertex)
      @vertices[from_vertex]
    end

    def walk(from_vertex)
      @vertices.fetch(from_vertex)
    end

    def include?(vertex)
      each_vertex.include?(vertex)
    end

    def loop?
      @loop
    end

    private

    def initialize_vertices(vertex1, vertex2)
      @loop = vertex1 == vertex2
    end
  end
end
