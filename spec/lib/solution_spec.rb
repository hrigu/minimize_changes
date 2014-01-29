require 'rspec'
require_relative '../../lib/solution'


describe 'Solution' do

  before :each do
    solution_string = "m1t1=2;m1t2=3;m2t1=4;m2t2=5;m1t3=9;m2t3=7;"
    @solution = Solution.new(solution_string)

  end

  describe "print" do
    it 'x' do
      @solution.parse
      @solution.print_solution
    end
  end

end
