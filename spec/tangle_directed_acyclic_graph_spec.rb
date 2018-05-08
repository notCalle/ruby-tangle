require 'tangle/directed/acyclic/graph'

RSpec.describe Tangle::Directed::Acyclic::Graph do
  before :example do
    @graph = Tangle::Directed::Acyclic::Graph.new
    @graph.add_vertex name: 'a'
    @graph.add_vertex name: 'b'
    @graph.add_vertex name: 'c'
    @graph.add_vertex name: 'd'
    @graph.add_edge 'a', 'b'
    @graph.add_edge 'b', 'c'
    @graph.add_edge 'a', 'd'
  end

  it 'is a specialization of a directed graph' do
    expect(@graph).to be_a Tangle::Directed::Graph
  end

  it 'can find the ancestor subgraph for a vertex' do
    expect { @graph.ancestor_subgraph('a') }.not_to raise_error
  end

  it 'can find the descendant subgraph for a vertex' do
    expect { @graph.descendant_subgraph('a') }.not_to raise_error
  end

  it 'can find the dependant subgraph for a vertex' do
    expect { @graph.dependant_subgraph('a') }.not_to raise_error
  end

  it 'has a topological ordering' do
    expect { @graph.topological_ordering }.not_to raise_error
  end

  it 'disallows edge cycles' do
    expect { @graph.add_edge('a') }.to raise_error Tangle::CyclicError
    expect { @graph.add_edge('c', 'a') }.to raise_error Tangle::CyclicError
  end

  it 'allows multiple paths to an ancestor' do
    expect { @graph.add_edge('a', 'c') }.not_to raise_error
    expect { @graph.add_edge('b', 'd') }.not_to raise_error
  end

  it 'allows multiedges' do
    expect { @graph.add_edge('a', 'b') }.not_to raise_error
  end

  context 'when given a vertex' do
    before :example do
      @graph = Tangle::DAG.new
      @vertex_a = @graph.add_vertex(name: 'a')
      @vertex_b = @graph.add_vertex(name: 'b')
      @graph.add_edge 'a', 'b'
      @vertex_c = @graph.add_vertex(name: 'c')
      @graph.add_edge 'b', 'c'
    end

    it 'can test ancestry' do
      expect(@graph).to respond_to :ancestor?
    end

    it 'can test descendancy' do
      expect(@graph).to respond_to :descendant?
    end

    it 'is an ancestor to itself' do
      expect(@graph.ancestor?(@vertex_a, @vertex_a)).to be true
    end

    it 'is a descendant to itself' do
      expect(@graph.descendant?(@vertex_a, @vertex_a)).to be true
    end

    it 'is an ancestor to its children' do
      expect(@graph.ancestor?(@vertex_a, @vertex_b)).to be true
    end

    it 'is a descendant of its parents' do
      expect(@graph.descendant?(@vertex_b, @vertex_a)).to be true
    end

    it 'is an ancestor through transitive parentness' do
      expect(@graph.parent?(@vertex_a, @vertex_c)).to be false
      expect(@graph.parent?(@vertex_a, @vertex_b)).to be true
      expect(@graph.parent?(@vertex_b, @vertex_c)).to be true
      expect(@graph.ancestor?(@vertex_a, @vertex_c)).to be true
    end

    it 'is a descendant through transitive childness' do
      expect(@graph.child?(@vertex_c, @vertex_a)).to be false
      expect(@graph.child?(@vertex_c, @vertex_b)).to be true
      expect(@graph.child?(@vertex_b, @vertex_a)).to be true
      expect(@graph.descendant?(@vertex_c, @vertex_a)).to be true
    end
  end
end
