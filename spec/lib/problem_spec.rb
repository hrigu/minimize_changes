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
      @problem.stripes.each { |s| p s }
    end
  end

  describe "gruen_orange_rot" do
    it "erstellt einen String in 10er Abständen. letzter Eintrag ist anzahl_timeslots" do
      anzahl_timeslots = 17
      @problem = Problem.new 1, [Array.new(anzahl_timeslots)]
      expect(@problem.gruen_orange_rot).to eq ("0\t0\t10\t10\t17\t17")
    end
  end
end