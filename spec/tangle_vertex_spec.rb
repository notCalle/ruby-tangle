require 'tangle/vertex'

RSpec.describe Tangle::Vertex do
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
      @vertex_d = @graph.add_vertex(name: 'd')
      @graph.add_edge 'b', 'd'
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

    it 'can test connectivity' do
      expect(@vertex_a).to respond_to :connected?
    end

    it 'is connected to itself' do
      expect(@vertex_a.connected?(@vertex_a)).to be true
    end

    it 'is connected to adjacent vertices' do
      expect(@vertex_a.connected?(@vertex_b)).to be true
    end

    it 'is connected through transitive adjacency' do
      expect(@vertex_a.adjacent?(@vertex_d)).to be false
      expect(@vertex_a.adjacent?(@vertex_b)).to be true
      expect(@vertex_b.adjacent?(@vertex_d)).to be true
      expect(@vertex_a.connected?(@vertex_d)).to be true
    end
  end

  context 'when in a directed graph' do
    before :context do
      @graph = Tangle::DiGraph.new
      @vertex_a = @graph.add_vertex(name: 'a')
      @vertex_b = @graph.add_vertex(name: 'b')
      @graph.add_edge 'a', 'b'
      @vertex_c = @graph.add_vertex(name: 'c')
      @graph.add_edge 'b', 'c'
    end

    it 'can find its parents' do
      expect(@vertex_a).to respond_to :parents
    end

    it 'can find its children' do
      expect(@vertex_a).to respond_to :children
    end

    it 'only includes direct ancestors in parents' do
      expect(@vertex_a.parents).to include @vertex_b
      expect(@vertex_a.parents).not_to include @vertex_c
    end

    it 'only includes direct descendants in children' do
      expect(@vertex_c.children).to include @vertex_b
      expect(@vertex_c.children).not_to include @vertex_a
    end

    it 'can test parentness' do
      expect(@vertex_a).to respond_to :parent?
    end

    it 'can test childness' do
      expect(@vertex_a).to respond_to :child?
    end

    it 'is only a parent to its direct descendants' do
      expect(@vertex_a.parent?(@vertex_b)).to be true
      expect(@vertex_a.parent?(@vertex_c)).to be false
    end

    it 'is only a child to its direct ancestors' do
      expect(@vertex_c.child?(@vertex_b)).to be true
      expect(@vertex_c.child?(@vertex_a)).to be false
    end

    it 'can test ancestry' do
      expect(@vertex_a).to respond_to :ancestor?
    end

    it 'can test descendancy' do
      expect(@vertex_a).to respond_to :descendant?
    end

    it 'is an ancestor to itself' do
      expect(@vertex_a.ancestor?(@vertex_a)).to be true
    end

    it 'is a descendant to itself' do
      expect(@vertex_a.descendant?(@vertex_a)).to be true
    end

    it 'is an ancestor to its children' do
      expect(@vertex_a.ancestor?(@vertex_b)).to be true
    end

    it 'is a descendant of its parents' do
      expect(@vertex_b.descendant?(@vertex_a)).to be true
    end

    it 'is an ancestor through transitive parentness' do
      expect(@vertex_a.parent?(@vertex_c)).to be false
      expect(@vertex_a.parent?(@vertex_b)).to be true
      expect(@vertex_b.parent?(@vertex_c)).to be true
      expect(@vertex_a.ancestor?(@vertex_c)).to be true
    end

    it 'is a descendant through transitive childness' do
      expect(@vertex_c.child?(@vertex_a)).to be false
      expect(@vertex_c.child?(@vertex_b)).to be true
      expect(@vertex_b.child?(@vertex_a)).to be true
      expect(@vertex_c.descendant?(@vertex_a)).to be true
    end
  end
end
