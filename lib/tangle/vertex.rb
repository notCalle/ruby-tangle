require 'delegate'
require 'pp'
require 'tangle/mixin'

module Tangle
  #
  # A named vertex in a graph
  #
  class Vertex
    include Tangle::Mixin::Initialize

    attr_reader :name

    # Create a new vertex
    #
    # Vertex.new(...) => Vertex
    #
    # Named arguments:
    #   name: anything that's hashable and unique within the graph
    def initialize(name: nil, **kwargs)
      @name = name

      initialize_mixins(**kwargs)
    end

    def to_s
      return name unless name.nil?
      super
    end
    alias inspect to_s
  end
end
