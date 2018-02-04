require 'tangle/simple/graph'

RSpec.describe Tangle::Simple::Graph do
  before :context do
    @graph = Tangle::Simple::Graph.new
  end

  it 'is a specialization of a graph' do
    expect(@graph).to be_a Tangle::Graph
  end

  it 'has simple edges' do
    expect(@graph.class::Edge).to be Tangle::Simple::Edge
  end
end
