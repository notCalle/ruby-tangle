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
end
