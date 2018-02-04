require 'tangle/simple/graph'

RSpec.describe Tangle::Simple::Edge do
  before :context do
    @graph = Tangle::Simple::Graph.new
    @vtx1 = @graph.add_vertex name: 'a'
    @vtx2 = @graph.add_vertex name: 'b'
    @edge = @graph.add_edge 'a', 'b'
  end

  it 'is a specialization of an edge' do
    expect(@edge).to be_a Tangle::Edge
  end

  it 'disallows loops' do
    expect { @graph.add_edge 'a' }.to raise_error Tangle::LoopError
  end

  it 'disallows multiple edges between a vertex pair' do
    expect { @graph.add_edge 'a', 'b' }.to raise_error Tangle::MultiEdgeError
    expect { @graph.add_edge 'b', 'a' }.to raise_error Tangle::MultiEdgeError
  end
end
