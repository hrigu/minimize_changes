#!/usr/bin/env ruby

require_relative 'lib/problem'
require_relative 'lib/problem_reader'
require_relative 'lib/minizinc_generator'
require_relative 'lib/solve_strategies'
require_relative 'lib/helpers'

include Helpers

problem_file = "eigene/big.xml"  #"level1.xml"  "brk_20120302_1_flow_45_group_10.xml"
#problem_file = "level3.xml"
solve_strategy = SolverSolveStrategy.new(employee_number: 5)
solve_strategy.prepare

out_info "Problem einlesen..."

problem = ProblemReader.new.read(problem_file)
p problem

out_info "mzn File erstellen..."
generator = MinizincGenerator.new(problem, solve_strategy)
generator.create_mzn_file
out_info "mzn File erstellt."

out_info "Nun Lösen mit Solver: "

solve_strategy.solve

out_info "FERTIG"
