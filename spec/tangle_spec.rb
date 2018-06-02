# frozen_string_literal: true

RSpec.describe Tangle do
  it 'has a version number' do
    expect(Tangle::VERSION).not_to be nil
  end

  it 'is a module' do
    expect(Tangle).to be_a Module
  end
end
