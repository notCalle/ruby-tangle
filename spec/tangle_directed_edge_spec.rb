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

  it 'has a parent vertex' do
    expect(@edge).to respond_to :parent
    expect(@edge.parent).to be @vtx2
  end

  it 'can tell if a vertex is the parent' do
    expect(@edge).to respond_to :parent?
    expect(@edge.parent?(@vtx1)).to be false
    expect(@edge.parent?(@vtx2)).to be true
  end

  it 'has a child vertex' do
    expect(@edge).to respond_to :child
    expect(@edge.child).to be @vtx1
  end

  it 'can tell if a vertex is the child' do
    expect(@edge).to respond_to :child?
    expect(@edge.child?(@vtx1)).to be true
    expect(@edge.child?(@vtx2)).to be false
  end
end
