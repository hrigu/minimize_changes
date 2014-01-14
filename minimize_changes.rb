#!/usr/bin/env ruby

require 'erb'
require 'nokogiri'
require_relative 'lib/classes'
require_relative 'lib/solve_strategies'
require_relative 'lib/helpers'
require 'fileutils'



include Helpers

#problem_file = "eigene/big.xml"  #"level1.xml"  "brk_20120302_1_flow_45_group_10.xml"
problem_file = "level1.xml"
solve_strategy = SolverSolveStrategy.new(employee_number: 2)
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
