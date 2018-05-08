RSpec.describe Tangle::Directed::Acyclic::Graph do
  before :example do
    @graph = Tangle::DAG[%w[a b c d], [%w[a b], %w[b c], %w[a d]]]
  end

  it 'is a specialization of a directed graph' do
    expect(@graph).to be_a Tangle::Directed::Graph
  end

  it 'has a topological ordering' do
    expect { @graph.topological_ordering }.not_to raise_error
  end

  it 'disallows edge cycles' do
    expect { @graph.add_edge('a') }.to raise_error Tangle::CyclicError
    expect { @graph.add_edge('c', 'a') }.to raise_error Tangle::CyclicError
  end

  it 'allows multiple paths to a successor' do
    expect { @graph.add_edge('a', 'c') }.not_to raise_error
    expect { @graph.add_edge('b', 'd') }.not_to raise_error
  end

  it 'allows multiedges' do
    expect { @graph.add_edge('a', 'b') }.not_to raise_error
  end
end
