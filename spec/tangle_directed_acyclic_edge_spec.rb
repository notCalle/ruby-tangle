require 'tangle/directed/acyclic/graph'

RSpec.describe Tangle::Directed::Acyclic::Edge do
  before :context do
    @graph = Tangle::Directed::Acyclic::Graph.new
    @vtx1 = @graph.add_vertex name: 'a'
    @vtx2 = @graph.add_vertex name: 'b'
    @edge = @graph.add_edge 'a', 'b'
  end

  it 'is a specialization of a directed edge' do
    expect(@edge).to be_a Tangle::Directed::Edge
  end

  it 'disallows edge cycles' do
    expect { @graph.add_edge('a') }.to raise_error Tangle::CyclicError
    expect { @graph.add_edge('b', 'a') }.to raise_error Tangle::CyclicError
  end

  it 'allows multiedges' do
    expect { @graph.add_edge('a', 'b') }.not_to raise_error
  end
end
