# frozen_string_literal: true

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
      currify :vertex, def in_edges(vertex)
        edges(vertex).select { |edge| edge.head?(vertex) }
      end

      # Return the direct predecessors of +vertex+
      currify :vertex, def direct_predecessors(vertex)
        in_edges(vertex).map(&:tail).to_set
      end

      # Is +other+ a direct predecessor of +vertex+?
      currify :vertex, def direct_predecessor?(vertex, other)
        direct_predecessors(vertex).include?(other)
      end

      # Return a breadth first enumerator for all predecessors
      currify :vertex, def predecessors(vertex)
        vertex_enumerator(vertex, :direct_predecessors)
      end

      # Is +other+ a predecessor of +vertex+?
      currify :vertex, def predecessor?(vertex, other)
        predecessors(vertex).any? { |vtx| other.eql?(vtx) }
      end

      # Return a subgraph with all predecessors of a +vertex+
      currify :vertex, def predecessor_subgraph(vertex, &selector)
        subgraph(predecessors(vertex), &selector)
      end

      # Return the outgoing edges for +vertex+
      currify :vertex, def out_edges(vertex)
        edges(vertex).select { |edge| edge.tail?(vertex) }
      end

      # Return the direct successors of +vertex+
      currify :vertex, def direct_successors(vertex)
        out_edges(vertex).map(&:head).to_set
      end

      # Is +other+ a direct successor of +vertex+?
      currify :vertex, def direct_successor?(vertex, other)
        direct_successors(vertex).include?(other)
      end

      # Return a breadth first enumerator for all successors
      currify :vertex, def successors(vertex)
        vertex_enumerator(vertex, :direct_successors)
      end

      # Is +other+ a successor of +vertex+?
      currify :vertex, def successor?(vertex, other)
        successors(vertex).any? { |vtx| other.eql?(vtx) }
      end

      # Return a subgraph with all successors of a +vertex+
      currify :vertex, def successor_subgraph(vertex, &selector)
        subgraph(successors(vertex), &selector)
      end

      # Return the in degree for +vertex+
      currify :vertex, def in_degree(vertex)
        in_edges(vertex).count
      end

      # Return the out degree for +vertex+
      currify :vertex, def out_degree(vertex)
        out_edges(vertex).count
      end

      # Is +vertex+ a sink in the graph?
      currify :vertex, def sink?(vertex)
        out_degree(vertex).zero?
      end

      # Is +vertex+ a source in the graph?
      currify :vertex, def source?(vertex)
        in_degree(vertex).zero?
      end

      # Is +vertex+ internal in the graph?
      currify :vertex, def internal?(vertex)
        !(sink?(vertex) || source?(vertex))
      end

      # Is the graph balanced?
      def balanced?
        vertices.all? { |vertex| in_degree(vertex) == out_degree(vertex) }
      end
    end
  end
end
