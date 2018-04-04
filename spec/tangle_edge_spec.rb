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

  it 'connects vertices' do
    expect(@edge).to respond_to :vertices
    [@vertex1, @vertex2].each do |vertex|
      expect(@edge).to include vertex
    end
  end

  it 'can be walked from one vertex to another' do
    expect(@edge).to respond_to :walk
    expect(@edge.walk(@vertex1)).to be @vertex2
    expect(@edge.walk(@vertex2)).to be @vertex1
  end

  context 'when cloned into a subgraph' do
    before :context do
      @mixin = Helpers::TestMixin
      @graph = Tangle::Graph[{ a: {} }, [%i[a a]], mixins: [@mixin]]
      @subgraph = @graph.subgraph
    end

    it 'retains all mixin methods' do
      @subgraph.edges.each do |edge|
        @mixin::Edge.public_instance_methods.each do |method|
          expect(edge).to respond_to method
        end
      end
    end
  end
end
