require 'tangle/graph'
require 'tangle/directed/edge'

module Tangle
  module Directed
    #
    # A directed graph
    class Graph < Tangle::Graph
      Edge = Tangle::Directed::Edge
      DEFAULT_MIXINS = [].freeze

      # Return the incoming edges for +vertex+
      def in_edges(vertex)
        vertex = get_vertex(vertex)
        edges(vertex).select { |edge| edge.head?(vertex) }
      end

      # Return the direct predecessors of +vertex+
      def direct_predecessors(vertex)
        vertex = get_vertex(vertex)
        Set.new(in_edges(vertex).map(&:tail))
      end

      # Is +other+ a direct predecessor of +vertex+?
      def direct_predecessor?(vertex, other)
        direct_predecessors(vertex).include?(other)
      end

      # Return a breadth first enumerator for all predecessors
      def predecessors(vertex)
        vertex = get_vertex(vertex)
        vertex_enumerator(vertex, :direct_predecessors)
      end

      # Is +other+ a predecessor of +vertex+?
      def predecessor?(vertex, other)
        predecessors(vertex).include?(other)
      end

      # Return a subgraph with all predecessors of a +vertex+
      def predecessor_subgraph(vertex, &selector)
        vertex = get_vertex(vertex)
        subgraph(predecessors(vertex), &selector)
      end

      # Return the outgoing edges for +vertex+
      def out_edges(vertex)
        vertex = get_vertex(vertex)
        edges(vertex).select { |edge| edge.tail?(vertex) }
      end

      # Return the direct successors of +vertex+
      def direct_successors(vertex)
        vertex = get_vertex(vertex)
        Set.new(out_edges(vertex).map(&:head))
      end

      # Is +other+ a direct successor of +vertex+?
      def direct_successor?(vertex, other)
        direct_successors(vertex).include?(other)
      end

      # Return a breadth first enumerator for all successors
      def successors(vertex)
        vertex = get_vertex(vertex)
        vertex_enumerator(vertex, :direct_successors)
      end

      # Is +other+ a successor of +vertex+?
      def successor?(vertex, other)
        successors(vertex).include?(other)
      end

      # Return a subgraph with all successors of a +vertex+
      def successor_subgraph(vertex, &selector)
        vertex = get_vertex(vertex)
        subgraph(successors(vertex), &selector)
      end

      # Return the in degree for +vertex+
      def in_degree(vertex)
        in_edges(vertex).count
      end

      # Return the out degree for +vertex+
      def out_degree(vertex)
        out_edges(vertex).count
      end

      # Is +vertex+ a sink in the graph?
      def sink?(vertex)
        out_degree(vertex).zero?
      end

      # Is +vertex+ a source in the graph?
      def source?(vertex)
        in_degree(vertex).zero?
      end

      # Is +vertex+ internal in the graph?
      def internal?(vertex)
        !(sink?(vertex) || source?(vertex))
      end

      # Is the graph balanced?
      def balanced?
        vertices.all? { |vertex| in_degree(vertex) == out_degree(vertex) }
      end
    end
  end
end
