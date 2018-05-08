PartialOrder = Tangle::Directed::Acyclic::PartialOrder
RSpec.describe PartialOrder do
  it 'is comparable' do
    expect(PartialOrder.ancestors).to include(Comparable)
  end

  before :example do
    @dag = Tangle::DAG[%w[a b c], [%w[a b]]]
    @order_a = PartialOrder.new(@dag, 'a')
    @order_b = PartialOrder.new(@dag, 'b')
    @order_c = PartialOrder.new(@dag, 'c')
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
