# frozen_string_literal: true

RSpec.describe Tangle::Simple::Graph do
  before :context do
    @graph = Tangle::Simple::Graph[%w[a b], [%w[a b]]]
  end

  it 'is a specialization of a graph' do
    expect(@graph).to be_a Tangle::Graph
  end

  it 'disallows loops' do
    expect { @graph.add_edge 'a' }.to raise_error Tangle::LoopError
  end

  it 'disallows multiple edges between a vertex pair' do
    expect { @graph.add_edge 'a', 'b' }.to raise_error Tangle::MultiEdgeError
    expect { @graph.add_edge 'b', 'a' }.to raise_error Tangle::MultiEdgeError
  end
end
