require 'tangle/vertex'

RSpec.describe Tangle::Vertex do
  it 'is a simple delegator' do
    expect(Tangle::Vertex.new).to be_a SimpleDelegator
  end

  it 'can delegate missing methods' do
    expect(Tangle::Vertex.new).not_to respond_to :fetch
    expect(Tangle::Vertex.new(delegate: {})).to respond_to :fetch
  end

  it 'can have a name' do
    expect(Tangle::Vertex.new).to respond_to :name
    expect(Tangle::Vertex.new(name: 'a').name).to eq 'a'
  end

  it 'can have edges' do
    expect(Tangle::Vertex.new).to respond_to :edges
    expect(Tangle::Vertex.new.edges).to eq []
  end

  context 'when in an undirected graph' do
    before :context do
      @graph = Tangle::Graph.new
      @vertex_a = @graph.add_vertex(name: 'a')
      @vertex_b = @graph.add_vertex(name: 'b')
      @graph.add_edge 'a', 'b'
      @vertex_c = @graph.add_vertex(name: 'c')
    end

    it 'can find its neighbours' do
      expect(@vertex_a).to respond_to :neighbours
    end

    it 'only includes adjacent vertices in neighbours' do
      expect(@vertex_a.neighbours).to include @vertex_b
      expect(@vertex_a.neighbours).not_to include @vertex_c
    end

    it 'can test adjacency' do
      expect(@vertex_a).to respond_to :adjacent?
    end

    it 'is only adjacent to its neighbours' do
      expect(@vertex_a.adjacent?(@vertex_b)).to be true
      expect(@vertex_a.adjacent?(@vertex_c)).to be false
    end
  end
end
