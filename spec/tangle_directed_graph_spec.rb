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

    it 'can find its parents' do
      expect(@graph).to respond_to :parents
    end

    it 'can find its children' do
      expect(@graph).to respond_to :children
    end

    it 'only includes direct ancestors in parents' do
      expect(@graph.parents(@vertex_a)).to include @vertex_b
      expect(@graph.parents(@vertex_a)).not_to include @vertex_c
    end

    it 'only includes direct descendants in children' do
      expect(@graph.children(@vertex_c)).to include @vertex_b
      expect(@graph.children(@vertex_c)).not_to include @vertex_a
    end

    it 'can test parentness' do
      expect(@graph).to respond_to :parent?
    end

    it 'can test childness' do
      expect(@graph).to respond_to :child?
    end

    it 'is only a parent to its direct descendants' do
      expect(@graph.parent?(@vertex_a, @vertex_b)).to be true
      expect(@graph.parent?(@vertex_a, @vertex_c)).to be false
    end

    it 'is only a child to its direct ancestors' do
      expect(@graph.child?(@vertex_c, @vertex_b)).to be true
      expect(@graph.child?(@vertex_c, @vertex_a)).to be false
    end
  end
end
