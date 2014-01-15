require 'rspec'
require_relative '../../lib/stripe'


describe 'StripeBuilder' do

  before :each do
    @bedarf = [
        [1, 1, 1],
        [0, 1, 1],
        [0, 0, 1],
        [1, 0, 1],
        [1, 1, 0],
        [0, 1, 1],
    ]

    @sb = StripesBuilder.new

  end
  it 'finds' do
    @sb.detect_product_stripes @bedarf
    p @sb
  end
end