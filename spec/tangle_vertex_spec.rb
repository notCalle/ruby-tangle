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
end
