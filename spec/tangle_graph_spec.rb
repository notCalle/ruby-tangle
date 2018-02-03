require 'tangle/graph'

RSpec.describe Tangle::Graph do
  before :context do
    @graph = Tangle::Graph.new
  end

  it 'is a simple object' do
    expect(@graph).to be_an Object
  end

  it 'can have vertices' do
    expect(@graph).to respond_to :vertices
  end

  it 'can have edges' do
    expect(@graph).to respond_to :edges
  end

  it 'can add new vertices' do
    expect(@graph.add_vertex(name: :a)).to be_a Tangle::Vertex
  end

  it 'can add new edges' do
    expect(@graph.add_edge(:a, :a)).to be_an Tangle::Edge
  end

  context 'when initialized' do
    context 'with nothing' do
      before :context do
        @graph = Tangle::Graph.new
      end

      it 'has no vertices' do
        expect(@graph.vertices).to be_empty
      end

      it 'has no edges' do
        expect(@graph.edges).to be_empty
      end
    end

    context 'with vertices and edges' do
      before :context do
        @graph = Tangle::Graph.new(vertices: { a: {}, b: {} }, edges: [%i[a b]])
      end

      it 'has vertices' do
        expect(@graph.vertices).not_to be_empty
      end

      it 'has edges' do
        expect(@graph.edges).not_to be_empty
      end
    end
  end
end
