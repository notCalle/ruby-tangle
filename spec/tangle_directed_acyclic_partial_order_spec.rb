PartialOrder = Tangle::Directed::Acyclic::PartialOrder
RSpec.describe PartialOrder do
  it 'is comparable' do
    expect(PartialOrder.ancestors).to include(Comparable)
  end

  before :example do
    @dag = Tangle::DAG.new
    @vertex_a = @dag.add_vertex name: 'a'
    @vertex_b = @dag.add_vertex name: 'b'
    @vertex_c = @dag.add_vertex name: 'c'
    @dag.add_edge 'a', 'b'
    @order_a = PartialOrder.new(@dag, @vertex_a)
    @order_b = PartialOrder.new(@dag, @vertex_b)
    @order_c = PartialOrder.new(@dag, @vertex_c)
  end

  it 'partially orders vertices' do
    # rubocop:disable Lint/UselessComparison
    expect(@order_a <= @order_a).to be true
    # rubocop:enable Lint/UselessComparison
    expect(@order_a <= @order_b).to be true
    expect(@order_b <= @order_a).to be false
    expect(@order_a <= @order_c).to be false
    expect(@order_c <= @order_a).to be false
  end
end
