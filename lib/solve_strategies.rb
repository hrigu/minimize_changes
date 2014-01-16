require 'fileutils'


class RunInfos
  def initialize
    @runs = []
  end

  def << run
    @runs << run
  end

  def inspect
    text = <<END
Anzahl Verstösse    Dauer     Anzahl globale Timeouts     Anzahl unsats
================    =====     =======================     =============
END
    @runs.each do |r|
      text << "#{r[:anzahl_verstoesse]}\t\t    #{r[:dauer].round(2)}\t#{r[:anzahl_globale_timeouts]}\t\t\t#{r[:anzahl_unsats]}\n"
    end
    text
  end
end

class SolveStrategy

  include Helpers
  SOLVER = :solver
  MINIZINC = :minizinc
  attr_reader :tool

  def initialize tool
    @tool = tool
    @run_infos = RunInfos.new
  end

  def vorbereiten
    system("cd files/created && rm *")
  end

end

class SolverSolveStrategy < SolveStrategy
  attr_reader :employees, :template_dir

  def initialize(employees: 4, problem: nil)
    super SOLVER
    @employees = employees
    @problem = problem
    @mzn_file = "created.mzn"
    @smt_file = "created.smt"
    @template_dir = "files/templates/end_pro_maschine_boolean/"
    @global_timeout = 5
    @solver_timeout = "2..2"
    @anzahl_runs = 10

    #@template_dir = "files/templates/global_end/"
  end

  def mzn_file_erstellen
    out_info "mzn File erstellen..."
    generator = MinizincGenerator.new(@problem, self)
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
    mpirun = "mpirun -n 5 ~/dienstplan/trunk/solver/solver_master/squeeze_ubuntu_12.04 --solver-name yices-smt --solver-path $(dirname $(which yices-smt)) --employee-number #{employees} --global-timeout #{@global_timeout} --solver-timeout #{@solver_timeout} --oi end_liegenlassen.txt --os beste_loesung.txt -i #{@smt_file} -s loesung.txt -g grenzen.txt --statistic statistic.txt"
    puts mpirun
    @anzahl_runs.times do
      timed do
        system("cd files/created && "+mpirun)
      end
    end
  end

  def timed
    start = Time.now
    yield
    anzahl_verstoesse = loesung_analysieren()
    info = {anzahl_verstoesse: anzahl_verstoesse, dauer: Time.now - start}
    statistic_analysieren(info)
    @run_infos << info
  end

  def loesung_analysieren
    anzahl_verstoesse = 0
    File.open("files/created/beste_loesung.txt", "r") do |infile|
      while (line = infile.gets)
        if line =~ /^end_wechsel_/
          line.slice!("end_wechsel_")
          a = line.split("=")
          anzahl_verstoesse += a[1].to_i
        end
      end
    end
    anzahl_verstoesse
  end

  def statistic_analysieren(info)
    anzahl_verstoesse = 0
    File.open("files/created/statistic.txt", "r") do |infile|
      while (line = infile.gets)
        if line =~ /^Number of global timeouts:/
          info[:anzahl_globale_timeouts] = (line[/\d+/]).to_i
        end
        if line =~ /^Number of unsat conditons:/
          info[:anzahl_unsats] = (line[/\d+/]).to_i
        end
      end
    end
    anzahl_verstoesse
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

  def info
    x = "Problem:\n"
    x << @problem.inspect << "\n"
    x << "Runs:\n"
    x << @run_infos.inspect
    x
  end

end