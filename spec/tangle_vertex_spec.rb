require 'tangle/vertex'

RSpec.describe Tangle::Vertex do
  it 'can have a name' do
    expect(Tangle::Vertex.new).to respond_to :name
    expect(Tangle::Vertex.new(name: 'a').name).to eq 'a'
  end
end
