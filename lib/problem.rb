require_relative "stripe"

class Problem
  # Bedarf der Produkte pro Timeslot: [0][3] = Bedarf fuer Produkt 0 im Timeslot 3
  attr_reader :bedarf
  attr_reader :anzahl_maschinen, :anzahl_produkte, :anzahl_timeslots


  def initialize anzahl_maschinen, bedarf
    @anzahl_maschinen, @bedarf = anzahl_maschinen, bedarf
    @anzahl_produkte = @bedarf.length
    @anzahl_timeslots = @bedarf[0].length
  end

  def detect_product_stripes
    stripes_builder = StripesBuilder.new
    bedarf.each_with_index do |p, pi|
      p.each_with_index do |ts, ti|
        stripes_builder.new_time_slot pi, ts, ti
      end
    end
    stripes_builder.finish
    p stripes_builder
  end

  def initial_loesung
    a = generate_initiale_loesung
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
    x = "" #Bedarf: (X-Achse: Index Timeslots, Y-Achse: Index Produkt) \n"
    #bedarf.each do |r|
    #  x << r.map { |p| p }.join(" ") << "\n"
    #end
    #{bedarf.inspect}
    x << "Anzahl Maschinen:  #{anzahl_maschinen}
Anzahl Produkte:   #{anzahl_produkte}
Anzahl Timeslots:  #{anzahl_timeslots}"
    #"initiale Lösung: \n"
    #    generate_initiale_loesung.each do |r|
    #      x << r.map { |p| p }.join(" ") << "\n"
    #    end
    x
  end

  private
  def generate_initiale_loesung
    # 2-D Array der Grösse anzahl_maschinen * anzahl_timeslots erstellen und mit 0 initialisieren
    a = Array.new(@anzahl_maschinen) { Array.new(@anzahl_timeslots, 0) }

    @anzahl_timeslots.times do |ti|
      current_m = 1
      @anzahl_produkte.times do |pi|
        if bedarf[pi][ti] == 1
          if current_m > a.size
            raise "Mehr Produkte in einem Timeslot als Maschinen (current_m = #{current_m}, a.size = #{a.size}"
          end
          a[current_m-1][ti] = pi+1 # Produktname (Zahl)
          current_m += 1
        end
      end
    end
    a
  end

end