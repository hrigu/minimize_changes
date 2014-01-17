require 'rspec'
require_relative '../../lib/problem'


describe 'Produkt' do

  before :each do

    b = [
        [1, 1, 0, 1, 1, 1],
        [0, 2, 2, 2, 0, 0],
        [3, 0, 3, 0, 3, 3]
    ]

    b = [
        [1, 1, 1, 0, 0, 0, 0, 0],
        [2, 2, 0, 0, 0, 0, 0, 0],
        [0, 3, 3, 3, 0, 0, 3, 3],
        [0, 0, 0, 0, 4, 4, 4, 0],
        [0, 0, 0, 5, 5, 5, 0, 0],
        [0, 0, 0, 0, 0, 0, 6, 6],
        [0, 0, 7, 7, 0, 0, 0, 0],
        [0, 0, 0, 0, 8, 8, 0, 0]
    ]

    # Diesen Bedarf bring man theoretisch auf 2 Maschinen, mit meinem Algo geht das aber nicht.
    b = [
        [1, 1, 1, 1, 0, 0, 1, 1, 1, 1],
        [0, 0, 2, 2, 2, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 3, 3, 3, 0, 0, 0],
    ]

    bedarf = b.map { |p| p.map { |c| c == 0 ? false : true } }

    #bedarf = [
    #    [true, true, false, false, false, false],
    #    [false, true, true, true, false, false],
    #    [false, false, false, false, true, true],
    #]
    @problem = Problem.new 2, bedarf
    @problem.detect_product_stripes

  end

  describe "initialloesung" do
    it 'xx' do

      @problem.bedarf.each_with_index do |p, pi|
        p p.map { |c| c ? pi+1 : 0 }
      end

      p @problem.send(:generate_initiale_loesung_v2)
      #p @problem.initial_loesung
    end
  end
end