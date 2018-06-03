# frozen_string_literal: true

RSpec.describe Tangle::Undirected::Edge do
  before :example do
    @edge = Tangle::Undirected::Edge.new('a', 'b')
  end

  it 'is a specialization of an Edge' do
    expect(@edge).to be_an Tangle::Edge
  end

  it 'can have a name' do
    edge_name = 'a<->b'
    expect {
      @named_edge = Tangle::Undirected::Edge.new('a', 'b', name: edge_name)
    }.not_to raise_error
    expect(@named_edge.name).to eq edge_name
  end

  it 'can enumerate vertices' do
    expect(@edge).to respond_to :each_vertex
    %w[a b].each do |vertex|
      expect(@edge).to include vertex
    end
  end

  it 'can be walked from one vertex to another' do
    expect(@edge).to respond_to :walk
    expect(@edge.walk('a')).to eq 'b'
    expect(@edge.walk('b')).to eq 'a'
  end
end
