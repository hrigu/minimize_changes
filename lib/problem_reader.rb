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