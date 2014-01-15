require 'fileutils'
class SolveStrategy

  include Helpers
  SOLVER = :solver
  MINIZINC = :minizinc
  attr_reader :tool

  def initialize tool
    @tool = tool
  end

  def vorbereiten
    system("cd files/created && rm *")
  end

end

class SolverSolveStrategy < SolveStrategy
  attr_reader :employees, :template_dir

  def initialize(employees: 2, problem: nil)
    super SOLVER
    @employees = employees
    @problem = problem
    @mzn_file = "created.mzn"
    @smt_file = "created.smt"
    @template_dir = "files/templates/end_pro_maschine/"
    #@template_dir = "files/templates/global_end/"
  end

  def mzn_file_erstellen
    out_info "mzn File erstellen..."
    generator = MinizincGenerator.new(problem, self)
    generator.create_mzn_file
    out_info "mzn File erstellt."
  end

  #
  # generiert flatzinc, smt, erste Lösung: alles um schlussendlich das File zu lösen
  #
  def erstelle_files()
    #system("cp #{@template_dir}grenzen_modifiziert.txt files/created/grenzen_modifiziert.txt")
    system("cd files/created && ~/dienstplan/trunk/solver/solver_master/processing.sh #{@mzn_file}")
  end

  def loese()
    mpirun = "mpirun -n 5 ~/dienstplan/trunk/solver/solver_master/squeeze_ubuntu_12.04 --solver-name yices-smt --solver-path $(dirname $(which yices-smt)) --employee-number #{employees} --global-timeout 100 --solver-timeout 2..10 --oi end_liegenlassen.txt --os beste_loesung.txt -i #{@smt_file} -s loesung.txt -g grenzen.txt --statistic statistic.txt"
    puts mpirun
    system("cd files/created && "+mpirun)
  end

  def loesung_zeigen()
    out_info "Beste Lösung"

    solution = nil
    File.open("files/created/beste_loesung.txt", "r") do |infile|
      while (line = infile.gets)
        solution = line
      end
    end
    out_info "Loesung schreiben "

    tempfile = File.open("files/created/#{@mzn_file}.tmp", "w")
    File.open("files/created/#{@mzn_file}", "r") do |infile|
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
    FileUtils.mv("files/created/#{@mzn_file}.tmp", "files/created/#{@mzn_file}")
    system("cd files/created && minizinc #{@mzn_file}")
  end

end