#!/usr/bin/env ruby

require_relative 'lib/helpers'
require_relative 'lib/problem'
require_relative 'lib/problem_reader'
require_relative 'lib/minizinc_generator'
require_relative 'lib/solve_strategies'

include Helpers

##problem_file = "eigene/big.xml"  #"level1.xml"  "brk_20120302_1_flow_45_group_10.xml"
## problem_file = "level1.xml"
#problem_file = "pst_2012017_all_products_ktns.xml"
##problem_file = "eigene/big_20_46.xml"
#
#
#out_info "Problem einlesen..."
#problem = ProblemReader.new.read(problem_file)

problem = Problem.new 2, bedarf

problem.detect_product_stripes
p problem

#solve_strategy = SolverSolveStrategy.new(employees: "4..8", problem: problem)  #"5..8"
#
#solve_strategy.vorbereiten
#solve_strategy.mzn_file_erstellen
#solve_strategy.erstelle_files
#solve_strategy.loese
#solve_strategy.loesung_zeigen

out_info "FERTIG"
