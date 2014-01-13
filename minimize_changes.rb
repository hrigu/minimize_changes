#!/usr/bin/env ruby

require 'erb'
require 'nokogiri'
require_relative 'lib/minimize_changes'

def out_info text
  puts "###################"
  puts "# #{text}"
  puts "###################"
end


#problem = ProblemReader.new.read("level1.xml")
#problem = ProblemReader.new.read("level2.xml")
problem = ProblemReader.new.read("level3.xml")
#problem = ProblemReader.new.read("level4.xml")
#problem = ProblemReader.new.read("level5.xml")
#problem = ProblemReader.new.read("level6.xml")
#problem = ProblemReader.new.read("brk_20120302_1_flow_45_group_10.xml")
#problem = ProblemReader.new.read("pst_2012017_all_products_ktns.xml")

out_info "Problem eingelesen:"
p problem

generator = MinizincGenerator.new problem
generator.create_mzn_for_solver_file

out_info "mzn File erstellt."


out_info "Nun Lösen mit Solver: "

mzn_file = "created_for_solver.mzn"
employee_number = 4

system("cd files/created && rm loesung.txt")

# generiert flatzinc, smt, erste Lösung: alles um schlussendlich das File zu lösen
system( "cd files/created && ~/dienstplan/trunk/solver/solver_master/processing.sh #{mzn_file}")
system( "cd files/created && mpirun -n 5 ~/dienstplan/trunk/solver/solver_master/squeeze_ubuntu_12.04 --solver-name yices-smt --solver-path $(dirname $(which yices-smt)) --employee-number #{employee_number} --global-timeout 10 --solver-timeout 2 --oi end_liegenlassen.txt --os beste_loesung.txt -i #{mzn_file} -s loesung.txt -g grenzen_modifiziert.txt --statistic statistic.txt")


# Lösung lesen

out_info "Beste Lösung"

File.open("files/created/beste_loesung.txt", "r") do |infile|
  while (line = infile.gets)
    puts "#{line}"
  end
end



out_info "FERTIG"
