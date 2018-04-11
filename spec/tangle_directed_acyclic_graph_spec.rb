require 'tangle/directed/acyclic/graph'

RSpec.describe Tangle::Directed::Acyclic::Graph do
  before :context do
    @graph = Tangle::Directed::Acyclic::Graph.new
    @graph.add_vertex name: 'a'
    @graph.add_vertex name: 'b'
    @graph.add_vertex name: 'c'
    @graph.add_vertex name: 'd'
    @graph.add_edge 'a', 'b'
    @graph.add_edge 'd', 'a'
    @graph.add_edge 'd', 'c'
  end

  it 'is a specialization of a directed graph' do
    expect(@graph).to be_a Tangle::Directed::Graph
  end

  it 'has directed acyclic edges' do
    expect(@graph.class::Edge).to be Tangle::Directed::Acyclic::Edge
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
end
