# frozen_string_literal: true

RSpec.describe Tangle::Undirected::Graph do
  before :context do
    @graph = Tangle::Undirected::Graph.new
  end

  it 'is a specialization of a base graph' do
    expect(@graph).to be_a Tangle::BaseGraph
  end

  it 'can have vertices' do
    expect(@graph).to respond_to :vertices
  end

  it 'can have edges' do
    expect(@graph).to respond_to :edges
  end

  it 'can add new vertices' do
    expect { @graph.add_vertex('a') }.not_to raise_error
  end

  it 'can add new undirected edges' do
    expect(@graph.add_edge('a', 'a')).to be_a Tangle::Undirected::Edge
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
        @graph = Tangle::Graph[%w[a]]
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

      it 'can find a connected subgraph for the vertex' do
        @subgraph = @graph.connected_subgraph('a')
        expect(@subgraph.vertices).to include 'a'
      end
    end

    context 'with a vertex, and a name' do
      before :example do
        @graph = Tangle::Graph.new
        @graph.add_vertex @vertex = 1, name: 'a'
      end

      it 'can fetch by name' do
        expect(@graph.fetch('a')).to be @vertex
        expect { @graph.fetch('b') }.to raise_error KeyError
        expect(@graph['a']).to be @vertex
        expect(@graph['b']).to be nil
      end
    end

    context 'with a named vertex' do
      before :example do
        @graph = Tangle::Graph.new
        @vertex = Struct.new(:name).new('a')
        @graph.add_vertex @vertex
      end

      it 'can fetch by name' do
        expect(@graph.fetch('a')).to be @vertex
        expect { @graph.fetch('b') }.to raise_error KeyError
        expect(@graph['a']).to be @vertex
        expect(@graph['b']).to be nil
      end
    end

    context 'with two vertices only' do
      before :context do
        @vertices = %w[a b]
        @graph = Tangle::Graph[@vertices]
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

      it 'can find a disconnected subgraph for each vertex' do
        @vertices.each do |vertex|
          subgraph = @graph.disconnected_subgraph(vertex)
          expect(subgraph.vertices).not_to include vertex
        end
      end
    end

    context 'with two vertices and an edge' do
      before :context do
        @graph = Tangle::Graph[%w[a b], [%w[a b]]]
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
      @graph = Tangle::Graph[%w[a b c d], [%w[a b], %w[b d]]]
      @graph.add_edge 'a', 'b'
      @graph.add_edge 'b', 'd'
    end

    it 'can find adjacent vertices' do
      expect(@graph).to respond_to :adjacent
    end

    it 'only includes adjacent vertices' do
      expect(@graph.adjacent('a')).to include 'b'
      expect(@graph.adjacent('a')).not_to include 'c'
    end

    it 'can test adjacency' do
      expect(@graph).to respond_to :adjacent?
    end

    it 'is only adjacent to its neighbours' do
      expect(@graph.adjacent?('a', 'b')).to be true
      expect(@graph.adjacent?('a', 'c')).to be false
    end

    it 'can test connectivity' do
      expect(@graph).to respond_to :connected?
    end

    it 'is connected to itself' do
      expect(@graph.connected?('a', 'a')).to be true
    end

    it 'is connected to adjacent vertices' do
      expect(@graph.connected?('a', 'b')).to be true
    end

    it 'is connected through transitive adjacency' do
      expect(@graph.adjacent?('a', 'd')).to be false
      expect(@graph.adjacent?('a', 'b')).to be true
      expect(@graph.adjacent?('b', 'd')).to be true
      expect(@graph.connected?('a', 'd')).to be true
    end
  end
end
