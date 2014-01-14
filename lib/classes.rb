class Problem
  # Bedarf der Produkte pro Timeslot: [0][3] = Bedarf fuer Produkt 0 im Timeslot 3
  attr_reader :bedarf
  attr_reader :anzahl_maschinen, :anzahl_produkte, :anzahl_timeslots


  def initialize anzahl_maschinen, bedarf
    @anzahl_maschinen, @bedarf = anzahl_maschinen, bedarf
    @anzahl_produkte = @bedarf.length
    @anzahl_timeslots = @bedarf[0].length
  end

  def initial_loesung
    a = Array.new(@anzahl_maschinen) { Array.new(@anzahl_timeslots, 0) }

    @anzahl_timeslots.times.each do |ti|
      current_m = 0
      @anzahl_produkte.times.each do |pi|
        if bedarf[pi][ti] == 1
          a[current_m][ti] = 1
          current_m += 1
        end
      end
    end
    l = ""
    a.each_with_index do |maschine, mi|
      maschine.each_with_index do |value, ti|
        l << "m#{mi+1}t#{ti+1} = #{value}; "
      end
      #l << "\n"
    end
    l
  end

  def inspect
    x = "Bedarf: (X-Achse: Index Timeslots, Y-Achse: Index Produkt) \n"
    bedarf.each do |r|
      x << r.map { |p| p }.join(" ") << "\n"
    end
#{bedarf.inspect}
    x << "Anzahl Maschinen:  #{anzahl_maschinen}
Anzahl Produkte:   #{anzahl_produkte}
Anzahl Timeslots:  #{anzahl_timeslots}
initiale Lösung:
#{initial_loesung}
    "
  end
end



class MinizincGenerator
  def initialize problem, solve_strategy
    @problem, @solve_strategy = problem, solve_strategy
  end

  def create_mzn_file
    template_file = File.open("files/templates/template.mzn.erb", 'r').read
    erb = ERB.new(template_file)
    File.open("files/created/created.mzn", 'w+') { |file| file.write(erb.result(binding)) }
  end
end


class ProblemReader

  #
  # Liest das Problem XML ein und erstellt das Problem Objekt
  #
  def read broblem_name
    f = File.open("files/problems/#{broblem_name}")
    doc = Nokogiri::XML(f)
    f.close

    bedarf = read_bedarf(doc)
    anzahl_maschinen = read_anzahl_maschinen(doc)

    Problem.new(anzahl_maschinen, bedarf)
  end

  private

  def read_anzahl_maschinen(doc)
    anzahl = 0
    doc.xpath('optimization_instance/machines/number').each do |node|
      anzahl = node.content.to_i
    end
    anzahl
  end

  def read_bedarf(doc)

    produkte = []
    doc.xpath('optimization_instance/production/*').each do |node|
      produkte << get_bedarf_for_product(node.content)
    end

    uniq_produkte = produkte.flatten.uniq.sort
    puts "Die verschiedenen Produkte: (Anzahl = #{uniq_produkte.size})"
    p uniq_produkte
    puts "Anzahl Timeslots: #{produkte.size}"

    bedarf = []
    uniq_produkte.size.times { bedarf << [] }

    produkte.each_with_index do |timeslot, t_index|
      uniq_produkte.each_with_index do |p, p_index|
        found = timeslot.index(p) ? 1 : 0
        bedarf[p_index][t_index] = found
      end
    end
    bedarf
  end

  def get_bedarf_for_product string
    string.split(",").map { |x| x.to_i }
  end

end