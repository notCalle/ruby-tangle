require 'tangle/directed/acyclic/graph'

RSpec.describe Tangle::Directed::Acyclic::Edge do
  before :context do
    @graph = Tangle::Directed::Acyclic::Graph.new
    @graph.add_vertex name: 'a'
    @graph.add_vertex name: 'b'
    @graph.add_vertex name: 'c'
    @edge = @graph.add_edge 'a', 'b'
    @graph.add_edge 'b', 'c'
  end

  it 'is a specialization of a directed edge' do
    expect(@edge).to be_a Tangle::Directed::Edge
  end

  it 'disallows edge cycles' do
    expect { @graph.add_edge('a') }.to raise_error Tangle::CyclicError
    expect { @graph.add_edge('c', 'a') }.to raise_error Tangle::CyclicError
  end

  it 'allows multiple paths to an ancestor' do
    expect { @graph.add_edge('a', 'c') }.not_to raise_error
  end

  it 'allows multiedges' do
    expect { @graph.add_edge('a', 'b') }.not_to raise_error
  end
end
