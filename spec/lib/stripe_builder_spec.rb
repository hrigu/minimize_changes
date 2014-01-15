require 'rspec'
require_relative '../../lib/stripe'


describe 'StripeBuilder' do

  before :each do
    @bedarf = [
        [true, true, true],
        [false, true, true],
        [false, false, true],
        [true, false, true],
        [true, true, false],
        [false, true, true],
    ]
    @sb = StripesBuilder.new

  end
  it 'finds' do
    @sb.detect_product_stripes @bedarf
    p @sb
  end
end