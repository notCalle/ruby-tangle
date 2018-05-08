require 'tangle/edge'

module Tangle
  module Directed
    #
    # An edge in a directed graph
    #
    class Edge < Tangle::Edge
      attr_reader :head, :tail

      def head?(vertex)
        @head == vertex
      end

      def tail?(vertex)
        @tail == vertex
      end

      def each_vertex(&block)
        [@tail, @head].each(&block)
      end

      def to_s
        "{#{@tail}-->#{@head}}"
      end
      alias inspect to_s

      private

      def initialize_vertices(tail, head = tail)
        super
        @tail = tail
        @head = head
        @vertices = { tail => head }
      end
    end
  end
end
