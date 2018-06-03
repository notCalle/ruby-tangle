# frozen_string_literal: true

require 'forwardable'
require_relative '../edge'

module Tangle
  module Undirected
    #
    # An edge in an undirected graph, connecting two vertices
    #
    class Edge < Tangle::Edge
      def each_vertex(&block)
        @vertices.each_key(&block)
      end

      def to_s
        vertex1, vertex2 = @vertices.keys
        "{#{vertex1}<->#{vertex2}}"
      end
      alias inspect to_s

      private

      def initialize_vertices(vertex1, vertex2 = vertex1)
        super
        @vertices = { vertex1 => vertex2, vertex2 => vertex1 }.freeze
      end
    end
  end
end
