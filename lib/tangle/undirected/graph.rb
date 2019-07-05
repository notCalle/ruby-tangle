# frozen_string_literal: true

require_relative '../base_graph'
require_relative 'edge'

module Tangle
  module Undirected
    #
    # Undirected graph
    #
    class Graph < Tangle::BaseGraph
      # Two vertices are adjacent if there is an edge between them
      def adjacent?(vertex, other)
        edges(vertex).any? { |edge| edge[vertex] == other }
      end

      # Return the set of adjacent vertices
      def adjacent(vertex)
        Set.new(edges(vertex).map { |edge| edge.walk(vertex) })
      end

      # Get the largest connected subgraph for a vertex.
      # Also aliased as :component and :connected_component
      #
      # connected_subgraph(vertex) => Graph
      #
      def connected_subgraph(vertex)
        subgraph { |other| connected?(vertex, other) }
      end
      alias component connected_subgraph
      alias connected_component connected_subgraph

      # Get the largest subgraph that is not connected to a vertex, or what's
      # left after removing the connected subgraph.
      #
      def disconnected_subgraph(vertex)
        subgraph { |other| !connected?(vertex, other) }
      end

      # A graph is connected if all vertices are connected to all vertices
      # An empty graph is disconnected.
      #
      def connected?(*tested_vertices)
        tested_vertices = vertices if tested_vertices.empty?
        return false if tested_vertices.empty?

        tested_vertices.combination(2).all? do |pair|
          this, that = pair.to_a
          reachable(this).any? { |other| other == that }
        end
      end

      # A graph is disconnected if any vertex is not connected to all other.
      # An empty graph is disconnected.
      #
      def disconnected?(*tested_vertices)
        !connected?(*tested_vertices)
      end

      # Return a breadth-first Enumerator for all reachable vertices,
      # by transitive adjacency.
      def reachable(start_vertex)
        vertex_enumerator(start_vertex, :adjacent)
      end

      private

      def new_edge(*args)
        Edge.new(*args)
      end
    end
  end
end
