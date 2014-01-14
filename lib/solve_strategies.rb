require 'fileutils'
class SolveStrategy
  SOLVER = :solver
  MINIZINC = :minizinc
  attr_reader :tool

  def initialize tool
    @tool = tool
  end
end

class SolverSolveStrategy < SolveStrategy
  attr_reader :employee_number

  def initialize(employee_number: 2)
    super SOLVER
    @employee_number = employee_number
  end

  def prepare
    system("cd files/created && rm *")
  end

  def solve
    mzn_file = "created.mzn"
    smt_file = "created.smt"

    system("cp files/templates/grenzen_modifiziert.txt files/created/grenzen_modifiziert.txt")

    #generiert flatzinc, smt, erste Lösung: alles um schlussendlich das File zu lösen
    system("cd files/created && ~/dienstplan/trunk/solver/solver_master/processing.sh #{mzn_file}")


    system("cd files/created && mpirun -n 5 ~/dienstplan/trunk/solver/solver_master/squeeze_ubuntu_12.04 --solver-name yices-smt --solver-path $(dirname $(which yices-smt)) --employee-number #{employee_number} --global-timeout 10 --solver-timeout 2 --oi end_liegenlassen.txt --os beste_loesung.txt -i #{smt_file} -s loesung.txt -g grenzen_modifiziert.txt --statistic statistic.txt")


    loesung_zeigen(mzn_file)

  end

  def loesung_zeigen(mzn_file)
    out_info "Beste Lösung"

    solution = nil
    File.open("files/created/beste_loesung.txt", "r") do |infile|
      while (line = infile.gets)
        solution = line
      end
    end


    out_info "Loesung schreiben "

    tempfile = File.open("files/created/#{mzn_file}.tmp", "w")
    File.open("files/created/#{mzn_file}", "r") do |infile|
      while (line = infile.gets)
        tempfile << line
        if line =~ /^%hook_for_show_solution/
          tempfile.puts "%Die Lösung\n"
          tempfile.puts solution
          tempfile.puts "\n"
        end
      end

    end

    tempfile.close
    FileUtils.mv("files/created/#{mzn_file}.tmp", "files/created/#{mzn_file}")
    system("cd files/created && minizinc #{mzn_file}")
  end

end