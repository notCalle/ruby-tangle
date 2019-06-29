# frozen_string_literal: true

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
    @other_dag = Tangle::DAG[%w[d]]
    @order_d = PartialOrder.new(@other_dag, 'd')
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

  it 'fails to order vertices in different graphs' do
    expect { @order_c <= @order_d }.to raise_error Tangle::GraphError
  end
end
