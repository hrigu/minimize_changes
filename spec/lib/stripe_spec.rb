require 'rspec'
require_relative '../../lib/stripe'


describe 'Stripe' do

  before :each do
    @stripe = Stripe.new(3, true, 4, 7) #Produkt 3, von index 4 bis 7

  end
  it 'can write constraint' do
    expect(@stripe.constraint).to eq('(plan[m,4] == 3) /\ (plan[m,5] == 3) /\ (plan[m,6] == 3) /\ (plan[m,7] == 3)')
  end
end