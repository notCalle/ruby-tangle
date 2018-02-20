module Tangle
  #
  # LoopError is raised when a looped edge is disallowed.
  #
  class LoopError < RuntimeError
    def initialize(reason = 'loops not allowed', *)
      super
    end
  end

  # MultiEdgeError is raised when multiple edges between a single pair of
  # vertices is disallowed.
  #
  class MultiEdgeError < RuntimeError
    def initialize(reason = 'multiedges not allowed', *)
      super
    end
  end

  # GraphError is raised when graph elements in an operation belong to
  # different graphs.
  #
  class GraphError < RuntimeError
    def initialize(reason = 'not in the same graph', *)
      super
    end
  end

  # CyclicError is raised when an edge cycle is disallowed.
  #
  class CyclicError < RuntimeError
    def initialize(reason = 'cycles not allowed', *)
      super
    end
  end
end
