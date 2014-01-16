require 'rspec'
require_relative '../../lib/problem'


describe 'Produkt' do

  before :each do
    bedarf = [
        [true, true, true],
        [false, true, true],
        [false, false, true],
        [true, false, true],
        [true, true, false],
        [false, true, true],
    ]
    @problem = Problem.new 5, bedarf

  end

  describe "anzahl_luecken_pro_timeslot" do
    it 'pro timeslot eine Zahl' do
      expect(@problem.anzahl_luecken_pro_timeslot).to eq([2, 1, 0])
    end
  end

  describe "generate_initiale_loesung" do
    it 'alle Produkte sind drin' do
      expected = [
          [1, 1, 1],
          [4, 2, 2],
          [5, 5, 3],
          [0, 6, 4],
          [0, 0, 6]
      ]
      #private Methode
      expect(@problem.send(:generate_initiale_loesung)).to eq(expected)
    end
  end

  describe "detect_product_stripes" do
    it 'bla' do
      @problem.detect_product_stripes
      @problem.stripes.each {|s| p s}
    end
  end
end