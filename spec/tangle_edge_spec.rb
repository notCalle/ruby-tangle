require 'tangle/vertex'
require 'tangle/edge'

RSpec.describe Tangle::Edge do
  before :example do
    @vertex1 = Tangle::Vertex.new
    @vertex2 = Tangle::Vertex.new
    @edge = Tangle::Edge.new(@vertex1, @vertex2)
  end

  it 'is a simple object' do
    expect(@edge).to be_a Object
  end

  it 'can have a name' do
    edge_name = 'vertex1<->vertex2'
    expect {
      @named_edge = Tangle::Edge.new(@vertex1, @vertex2, name: edge_name)
    }.not_to raise_error
    expect(@named_edge.name).to eq edge_name
  end

  it 'can enumerate vertices' do
    expect(@edge).to respond_to :each_vertex
    [@vertex1, @vertex2].each do |vertex|
      expect(@edge).to include vertex
    end
  end

  it 'can be walked from one vertex to another' do
    expect(@edge).to respond_to :walk
    expect(@edge.walk(@vertex1)).to be @vertex2
    expect(@edge.walk(@vertex2)).to be @vertex1
  end
end
