# frozen_string_literal: true

RSpec.describe Tangle::BaseGraph do
  before :context do
    @graph = Tangle::BaseGraph.new
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
    expect { @graph.add_vertex('a') }.not_to raise_error
  end
end
