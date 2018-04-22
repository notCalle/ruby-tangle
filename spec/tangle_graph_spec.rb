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
    expect(@graph.add_edge(:a, :a)).to be_a Tangle::Edge
  end

  it 'can test (dis)connectedness' do
    expect(@graph).to respond_to :connected?
    expect(@graph).to respond_to :disconnected?
  end

  it 'can produce (dis)connected subgraphs' do
    expect(@graph).to respond_to :connected_subgraph
    expect(@graph).to respond_to :disconnected_subgraph
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

      it 'is disconnected' do
        expect(@graph.disconnected?).to be true
        expect(@graph.connected?).to be false
      end
    end

    context 'with one vertex only' do
      before :context do
        @graph = Tangle::Graph[{ a: {} }]
      end

      it 'has a vertex' do
        expect(@graph.vertices).not_to be_empty
      end

      it 'has no edges' do
        expect(@graph.edges).to be_empty
      end

      it 'is connected' do
        expect(@graph.connected?).to be true
        expect(@graph.disconnected?).to be false
      end
    end

    context 'with two vertices only' do
      before :context do
        @graph = Tangle::Graph[{ a: {}, b: {} }]
      end

      it 'has vertices' do
        expect(@graph.vertices).not_to be_empty
      end

      it 'has no edges' do
        expect(@graph.edges).to be_empty
      end

      it 'is disconnected' do
        expect(@graph.disconnected?).to be true
        expect(@graph.connected?).to be false
      end
    end

    context 'with two vertices and an edge' do
      before :context do
        @graph = Tangle::Graph[{ a: {}, b: {} }, [%i[a b]]]
      end

      it 'has vertices' do
        expect(@graph.vertices).not_to be_empty
      end

      it 'has an edge' do
        expect(@graph.edges).not_to be_empty
      end

      it 'is connected' do
        expect(@graph.connected?).to be true
        expect(@graph.disconnected?).to be false
      end
    end
  end

  context 'when subgraphed' do
    before :context do
      @mixin = Helpers::TestMixin
      @graph = Tangle::Graph.new(mixins: [@mixin])
      @subgraph = @graph.subgraph
    end

    it 'retains all mixin methods' do
      @mixin::Graph.public_instance_methods.each do |method|
        expect(@subgraph).to respond_to method
      end
    end
  end

  context 'given a vertex' do
    before :context do
      @graph = Tangle::Graph.new
      @vertex_a = @graph.add_vertex(name: 'a')
      @vertex_b = @graph.add_vertex(name: 'b')
      @graph.add_edge 'a', 'b'
      @vertex_c = @graph.add_vertex(name: 'c')
      @vertex_d = @graph.add_vertex(name: 'd')
      @graph.add_edge 'b', 'd'
    end

    it 'can find adjacent vertices' do
      expect(@graph).to respond_to :adjacent
    end

    it 'only includes adjacent vertices' do
      expect(@graph.adjacent(@vertex_a)).to include @vertex_b
      expect(@graph.adjacent(@vertex_a)).not_to include @vertex_c
    end

    it 'can test adjacency' do
      expect(@graph).to respond_to :adjacent?
    end

    it 'is only adjacent to its neighbours' do
      expect(@graph.adjacent?(@vertex_a, @vertex_b)).to be true
      expect(@graph.adjacent?(@vertex_a, @vertex_c)).to be false
    end

    it 'can test connectivity' do
      expect(@graph).to respond_to :connected?
    end

    it 'is connected to itself' do
      expect(@graph.connected?(@vertex_a, @vertex_a)).to be true
    end

    it 'is connected to adjacent vertices' do
      expect(@graph.connected?(@vertex_a, @vertex_b)).to be true
    end

    it 'is connected through transitive adjacency' do
      expect(@graph.adjacent?(@vertex_a, @vertex_d)).to be false
      expect(@graph.adjacent?(@vertex_a, @vertex_b)).to be true
      expect(@graph.adjacent?(@vertex_b, @vertex_d)).to be true
      expect(@graph.connected?(@vertex_a, @vertex_d)).to be true
    end
  end
end
