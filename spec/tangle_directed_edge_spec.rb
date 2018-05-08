require 'tangle/directed/graph'

RSpec.describe Tangle::Directed::Edge do
  before :context do
    @graph = Tangle::Directed::Graph.new
    @vtx1 = @graph.add_vertex name: 'a'
    @vtx2 = @graph.add_vertex name: 'b'
    @edge = @graph.add_edge 'a', 'b'
  end

  it 'is a specialization of an edge' do
    expect(@edge).to be_a Tangle::Edge
  end

  it 'has a head vertex' do
    expect(@edge).to respond_to :head
    expect(@edge.head).to be @vtx2
  end

  it 'can tell if a vertex is the head' do
    expect(@edge).to respond_to :head?
    expect(@edge.head?(@vtx1)).to be false
    expect(@edge.head?(@vtx2)).to be true
  end

  it 'has a tail vertex' do
    expect(@edge).to respond_to :tail
    expect(@edge.tail).to be @vtx1
  end

  it 'can tell if a vertex is the tail' do
    expect(@edge).to respond_to :tail?
    expect(@edge.tail?(@vtx1)).to be true
    expect(@edge.tail?(@vtx2)).to be false
  end
end
