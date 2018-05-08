RSpec.describe Tangle::Directed::Edge do
  before :context do
    @graph = Tangle::Directed::Graph[%w[a b]]
    @edge = @graph.add_edge('a', 'b')
  end

  it 'is a specialization of an edge' do
    expect(@edge).to be_a Tangle::Edge
  end

  it 'has a head vertex' do
    expect(@edge).to respond_to :head
    expect(@edge.head).to eq 'b'
  end

  it 'can tell if a vertex is the head' do
    expect(@edge).to respond_to :head?
    expect(@edge.head?('a')).to be false
    expect(@edge.head?('b')).to be true
  end

  it 'has a tail vertex' do
    expect(@edge).to respond_to :tail
    expect(@edge.tail).to eq 'a'
  end

  it 'can tell if a vertex is the tail' do
    expect(@edge).to respond_to :tail?
    expect(@edge.tail?('a')).to be true
    expect(@edge.tail?('b')).to be false
  end
end
