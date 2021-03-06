#!/usr/bin/env ruby

require_relative 'lib/helpers'
require_relative 'lib/problem'
require_relative 'lib/problem_reader'
require_relative 'lib/minizinc_generator'
require_relative 'lib/solve_strategies'

include Helpers

#problem_file = "eigene/big.xml"  #"level1.xml"  "brk_20120302_1_flow_45_group_10.xml"
#problem_file = "eigene/m1_p1_ts1.xml"
#problem_file = "level3.xml"
#problem_file = "pst_2012017_all_products_ktns.xml"
problem_file = "eigene/big_20_46.xml"
#problem_file = "eigene/big_10_10.xml"
#
#
#out_info "Problem einlesen..."
problem = ProblemReader.new.read(problem_file)
problem.detect_product_stripes
p problem
puts "Anzahl Streifen: #{problem.stripes.size}"
puts "Anzahl Einzelzellen: #{problem.stripes_builder.anzahl_einzelzellen}"

# solve_strategy = SolverSolveStrategy.new(employees: "4", global_timeout: 20, solver_timeout: "14..18", anzahl_runs: 1, problem: problem)  #"5..8"
#solve_strategy = AnzahlWechselProMaschine.new(employees: "4", global_timeout: 20, solver_timeout: "14..18", anzahl_runs: 1, problem: problem)  #"5..8"
#solve_strategy = XaGlobalAnzahlWechsel.new(employees: "4", global_timeout: 20, solver_timeout: "14..18", anzahl_runs: 1, problem: problem)  #"5..8"
#solve_strategy = XaAnzahlWechselProMaschine.new(employees: "4", global_timeout: 20, solver_timeout: "14..18", anzahl_runs: 1, problem: problem)  #"5..8"
solve_strategy = StreifenVerteilen.new(employees: problem.anzahl_maschinen, global_timeout: 20, solver_timeout: "14..18", anzahl_runs: 1, problem: problem)  #"5..8"

solve_strategy.vorbereiten
solve_strategy.mzn_file_erstellen
solve_strategy.erstelle_files
solve_strategy.loese
solve_strategy.loesung_zeigen

out_info "FERTIG:"
puts solve_strategy.info
