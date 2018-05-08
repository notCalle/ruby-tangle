require 'tangle/directed/graph'

RSpec.describe Tangle::Directed::Graph do
  before :context do
    @graph = Tangle::Directed::Graph.new
  end

  it 'is a specialization of a graph' do
    expect(@graph).to be_a Tangle::Graph
  end

  it 'has directed edges' do
    expect(@graph.class::Edge).to be Tangle::Directed::Edge
  end

  context 'given a vertex' do
    before :context do
      @graph = Tangle::DiGraph.new
      @vertex_a = @graph.add_vertex(name: 'a')
      @vertex_b = @graph.add_vertex(name: 'b')
      @graph.add_edge 'a', 'b'
      @vertex_c = @graph.add_vertex(name: 'c')
      @graph.add_edge 'b', 'c'
    end

    it 'can find its direct successors' do
      expect(@graph).to respond_to :direct_successors
      expect(@graph.direct_successors(@vertex_a)).to include @vertex_b
      expect(@graph.direct_successors(@vertex_a)).not_to include @vertex_c
    end

    it 'can find its direct predecessors' do
      expect(@graph).to respond_to :direct_predecessors
      expect(@graph.direct_predecessors(@vertex_c)).to include @vertex_b
      expect(@graph.direct_predecessors(@vertex_c)).not_to include @vertex_a
    end

    it 'can test if another vertex is a direct successor' do
      expect(@graph).to respond_to :direct_successor?
      expect(@graph.direct_successor?(@vertex_a, @vertex_b)).to be true
      expect(@graph.direct_successor?(@vertex_a, @vertex_c)).to be false
    end

    it 'can test if another vertex is a direct predecessor' do
      expect(@graph).to respond_to :direct_predecessor?
      expect(@graph.direct_predecessor?(@vertex_c, @vertex_b)).to be true
      expect(@graph.direct_predecessor?(@vertex_c, @vertex_a)).to be false
    end

    it 'can test if another vertex is a successor' do
      expect(@graph).to respond_to :successor?
    end

    it 'is a successor to itself' do
      expect(@graph.successor?(@vertex_a, @vertex_a)).to be true
    end

    it 'can test if another vertex is a predecessor' do
      expect(@graph).to respond_to :predecessor?
    end

    it 'is a predecessor to itself' do
      expect(@graph.predecessor?(@vertex_a, @vertex_a)).to be true
    end

    it 'is a successor of its direct predecessors' do
      expect(@graph.successor?(@vertex_a, @vertex_b)).to be true
    end

    it 'is a predecessor of its direct successors' do
      expect(@graph.predecessor?(@vertex_b, @vertex_a)).to be true
    end

    it 'is a successor through direct successors' do
      expect(@graph.direct_successor?(@vertex_a, @vertex_c)).to be false
      expect(@graph.direct_successor?(@vertex_a, @vertex_b)).to be true
      expect(@graph.direct_successor?(@vertex_b, @vertex_c)).to be true
      expect(@graph.successor?(@vertex_a, @vertex_c)).to be true
    end

    it 'is a predecessor through direct predecessors' do
      expect(@graph.direct_predecessor?(@vertex_c, @vertex_a)).to be false
      expect(@graph.direct_predecessor?(@vertex_c, @vertex_b)).to be true
      expect(@graph.direct_predecessor?(@vertex_b, @vertex_a)).to be true
      expect(@graph.predecessor?(@vertex_c, @vertex_a)).to be true
    end

    it 'can measure its in degree' do
      expect(@graph).to respond_to :in_degree
      expect(@graph.in_degree(@vertex_a)).to be 0
      expect(@graph.in_degree(@vertex_b)).to be 1
      expect(@graph.in_degree(@vertex_c)).to be 1
    end

    it 'can measure its out degree' do
      expect(@graph).to respond_to :out_degree
      expect(@graph.out_degree(@vertex_a)).to be 1
      expect(@graph.out_degree(@vertex_b)).to be 1
      expect(@graph.out_degree(@vertex_c)).to be 0
    end

    it 'can detect source vertices' do
      expect(@graph).to respond_to :source?
      expect(@graph.source?(@vertex_a)).to be true
      expect(@graph.source?(@vertex_b)).to be false
      expect(@graph.source?(@vertex_c)).to be false
    end

    it 'can detect sink vertices' do
      expect(@graph).to respond_to :sink?
      expect(@graph.sink?(@vertex_a)).to be false
      expect(@graph.sink?(@vertex_b)).to be false
      expect(@graph.sink?(@vertex_c)).to be true
    end

    it 'can detect internal vertices' do
      expect(@graph).to respond_to :internal?
      expect(@graph.internal?(@vertex_a)).to be false
      expect(@graph.internal?(@vertex_b)).to be true
      expect(@graph.internal?(@vertex_c)).to be false
    end
  end
end
