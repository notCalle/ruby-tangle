# frozen_string_literal: true

require_relative '../base_graph'
require_relative 'edge'

module Tangle
  module Directed
    #
    # A directed graph
    class Graph < Tangle::BaseGraph
      # Return the incoming edges for +vertex+
      def in_edges(vertex)
        edges(vertex).select { |edge| edge.head?(vertex) }
      end
      currify :vertex, :in_edges

      # Return the direct predecessors of +vertex+
      def direct_predecessors(vertex)
        in_edges(vertex).map(&:tail).to_set
      end
      currify :vertex, :direct_predecessors

      # Is +other+ a direct predecessor of +vertex+?
      def direct_predecessor?(vertex, other)
        direct_predecessors(vertex).include?(other)
      end
      currify :vertex, :direct_predecessor?

      # Return a breadth first enumerator for all predecessors
      def predecessors(vertex)
        vertex_enumerator(vertex, :direct_predecessors)
      end
      currify :vertex, :predecessors

      # Is +other+ a predecessor of +vertex+?
      def predecessor?(vertex, other)
        predecessors(vertex).any? { |vtx| other.eql?(vtx) }
      end
      currify :vertex, :predecessor?

      # Return a subgraph with all predecessors of a +vertex+
      def predecessor_subgraph(vertex, &selector)
        subgraph(predecessors(vertex), &selector)
      end
      currify :vertex, :predecessor_subgraph

      # Return the outgoing edges for +vertex+
      def out_edges(vertex)
        edges(vertex).select { |edge| edge.tail?(vertex) }
      end
      currify :vertex, :out_edges

      # Return the direct successors of +vertex+
      def direct_successors(vertex)
        out_edges(vertex).map(&:head).to_set
      end
      currify :vertex, :direct_successors

      # Is +other+ a direct successor of +vertex+?
      def direct_successor?(vertex, other)
        direct_successors(vertex).include?(other)
      end
      currify :vertex, :direct_successor?

      # Return a breadth first enumerator for all successors
      def successors(vertex)
        vertex_enumerator(vertex, :direct_successors)
      end
      currify :vertex, :successors

      # Is +other+ a successor of +vertex+?
      def successor?(vertex, other)
        successors(vertex).any? { |vtx| other.eql?(vtx) }
      end
      currify :vertex, :successor?

      # Return a subgraph with all successors of a +vertex+
      def successor_subgraph(vertex, &selector)
        subgraph(successors(vertex), &selector)
      end
      currify :vertex, :successor_subgraph

      # Return the in degree for +vertex+
      def in_degree(vertex)
        in_edges(vertex).count
      end
      currify :vertex, :in_degree

      # Return the out degree for +vertex+
      def out_degree(vertex)
        out_edges(vertex).count
      end
      currify :vertex, :out_degree

      # Is +vertex+ a sink in the graph?
      def sink?(vertex)
        out_degree(vertex).zero?
      end
      currify :vertex, :sink?

      # Is +vertex+ a source in the graph?
      def source?(vertex)
        in_degree(vertex).zero?
      end
      currify :vertex, :source?

      # Is +vertex+ internal in the graph?
      def internal?(vertex)
        !(sink?(vertex) || source?(vertex))
      end
      currify :vertex, :internal?

      # Is the graph balanced?
      def balanced?
        vertices.all? { |vertex| in_degree(vertex) == out_degree(vertex) }
      end

      private

      def new_edge(*args, **kwargs)
        Edge.new(*args, **kwargs)
      end
    end
  end
end
