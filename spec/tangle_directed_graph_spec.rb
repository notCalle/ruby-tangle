# frozen_string_literal: true

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
      @graph = Tangle::DiGraph[%w[a b c], [%w[a b], %w[b c]]]
    end

    it 'can find its direct successors' do
      expect(@graph).to respond_to :direct_successors
      expect(@graph.direct_successors('a')).to include 'b'
      expect(@graph.direct_successors('a')).not_to include 'c'
    end

    it 'can find its direct predecessors' do
      expect(@graph).to respond_to :direct_predecessors
      expect(@graph.direct_predecessors('c')).to include 'b'
      expect(@graph.direct_predecessors('c')).not_to include 'a'
    end

    it 'can test if another vertex is a direct successor' do
      expect(@graph).to respond_to :direct_successor?
      expect(@graph.direct_successor?('a', 'b')).to be true
      expect(@graph.direct_successor?('a', 'c')).to be false
    end

    it 'can test if another vertex is a direct predecessor' do
      expect(@graph).to respond_to :direct_predecessor?
      expect(@graph.direct_predecessor?('c', 'b')).to be true
      expect(@graph.direct_predecessor?('c', 'a')).to be false
    end

    it 'can test if another vertex is a successor' do
      expect(@graph).to respond_to :successor?
    end

    it 'is a successor to itself' do
      expect(@graph.successor?('a', 'a')).to be true
    end

    it 'can test if another vertex is a predecessor' do
      expect(@graph).to respond_to :predecessor?
    end

    it 'is a predecessor to itself' do
      expect(@graph.predecessor?('a', 'a')).to be true
    end

    it 'is a successor of its direct predecessors' do
      expect(@graph.successor?('a', 'b')).to be true
    end

    it 'is a predecessor of its direct successors' do
      expect(@graph.predecessor?('b', 'a')).to be true
    end

    it 'is a successor through direct successors' do
      expect(@graph.direct_successor?('a', 'c')).to be false
      expect(@graph.direct_successor?('a', 'b')).to be true
      expect(@graph.direct_successor?('b', 'c')).to be true
      expect(@graph.successor?('a', 'c')).to be true
    end

    it 'is a predecessor through direct predecessors' do
      expect(@graph.direct_predecessor?('c', 'a')).to be false
      expect(@graph.direct_predecessor?('c', 'b')).to be true
      expect(@graph.direct_predecessor?('b', 'a')).to be true
      expect(@graph.predecessor?('c', 'a')).to be true
    end

    it 'can measure its in degree' do
      expect(@graph).to respond_to :in_degree
      expect(@graph.in_degree('a')).to be 0
      expect(@graph.in_degree('b')).to be 1
      expect(@graph.in_degree('c')).to be 1
    end

    it 'can measure its out degree' do
      expect(@graph).to respond_to :out_degree
      expect(@graph.out_degree('a')).to be 1
      expect(@graph.out_degree('b')).to be 1
      expect(@graph.out_degree('c')).to be 0
    end

    it 'can detect source vertices' do
      expect(@graph).to respond_to :source?
      expect(@graph.source?('a')).to be true
      expect(@graph.source?('b')).to be false
      expect(@graph.source?('c')).to be false
    end

    it 'can detect sink vertices' do
      expect(@graph).to respond_to :sink?
      expect(@graph.sink?('a')).to be false
      expect(@graph.sink?('b')).to be false
      expect(@graph.sink?('c')).to be true
    end

    it 'can detect internal vertices' do
      expect(@graph).to respond_to :internal?
      expect(@graph.internal?('a')).to be false
      expect(@graph.internal?('b')).to be true
      expect(@graph.internal?('c')).to be false
    end
  end
end
