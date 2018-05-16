require 'tangle/mixin/directory'

RSpec.describe Tangle::Mixin::Directory do
  it 'is a module' do
    expect(Tangle::Mixin::Directory).to be_a Module
  end

  it 'extends Graph' do
    expect(Tangle::Mixin::Directory::Graph).to be_a Module
  end

  context 'a directory graph' do
    before :context do
      @mixins = [Tangle::Mixin::Directory]
      @root = '.'
      @loader = lambda do |graph:, path:, parent:, **|
        graph.add_vertex(path)
        graph.add_edge(parent, path) unless parent.nil?
      end
      @kwargs = {
        mixins: @mixins,
        directory: { root: @root, loaders: [@loader] }
      }
    end

    it 'requires a directory root' do
      expect {
        Tangle::DiGraph.new(mixins: @mixins, directory: { loaders: [] })
      }.to raise_error KeyError
    end

    it 'requires a list of loaders' do
      expect {
        Tangle::DiGraph.new(mixins: @mixins, directory: { root: '.' })
      }.to raise_error KeyError
    end

    it 'remembers its root directory' do
      expect(Tangle::DiGraph.new(@kwargs).root_directory).to eq @root
    end
  end
end
