require 'tangle/directed/acyclic/graph'

RSpec.describe Tangle::Directed::Acyclic::Graph do
  before :context do
    @graph = Tangle::Directed::Acyclic::Graph.new
  end

  it 'is a specialization of a directed graph' do
    expect(@graph).to be_a Tangle::Directed::Graph
  end

  it 'has directed acyclic edges' do
    expect(@graph.class::Edge).to be Tangle::Directed::Acyclic::Edge
  end
end
