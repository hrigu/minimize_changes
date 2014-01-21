require_relative "stripe"

class Problem
  # Bedarf der Produkte pro Timeslot: [0][3] = Bedarf fuer Produkt 0 im Timeslot 3: boolean
  attr_accessor :name
  attr_reader :bedarf
  attr_reader :anzahl_maschinen, :anzahl_produkte, :anzahl_timeslots
  attr_reader :stripes_builder, :stripes


  def initialize anzahl_maschinen, bedarf, name = "unbekannt"
    @name = name
    @anzahl_maschinen, @bedarf = anzahl_maschinen, bedarf
    @anzahl_produkte = @bedarf.length
    @anzahl_timeslots = @bedarf[0].length
  end

  def detect_product_stripes
    @stripes_builder = StripesBuilder.new
    @stripes_builder.detect_product_stripes @bedarf
    @stripes = @stripes_builder.stripes
    #p stripes_builder
  end

  #TODO Die Stripes dürfen nicht verschnitten werden
  def initial_loesung
    a = generate_initiale_loesung
    l = ""
    a.each_with_index do |maschine, mi|
      maschine.each_with_index do |value, ti|
        l << "m#{mi+1}t#{ti+1} = #{value};"
      end
      #l << "\n"
    end
    l
  end

  def gruen_orange_rot
    steps = []
    current_step = 0
    while current_step < @anzahl_timeslots
      steps << "#{current_step}\t#{current_step}"
      current_step += 10
    end
    steps << "#{@anzahl_timeslots}\t#{@anzahl_timeslots}"
    steps.join("\t")
  end

  def anzahl_luecken_pro_timeslot
    anzahl_timeslots.times.map do |ti|
      sum_der_gesetzten_produkte = 0
      #array.inject{|sum, x| sum + x ? 1 : 0}
      @anzahl_produkte.times do |pi|
        sum_der_gesetzten_produkte += @bedarf[pi][ti] ? 1 : 0
      end
      @anzahl_maschinen - sum_der_gesetzten_produkte
    end

  end

  def inspect
    x = "" #Bedarf: (X-Achse: Index Timeslots, Y-Achse: Index Produkt) \n"
    #bedarf.each do |r|
    #  x << r.map { |p| p }.join(" ") << "\n"
    #end
    #{bedarf.inspect}
    x << "name:              #{name}
Anzahl Maschinen:  #{anzahl_maschinen}
Anzahl Produkte:   #{anzahl_produkte}
Anzahl Timeslots:  #{anzahl_timeslots}
Anzahl Streifen:   #{stripes.size}"

    #"initiale Lösung: \n"
    #    generate_initiale_loesung.each do |r|
    #      x << r.map { |p| p }.join(" ") << "\n"
    #    end
    x
  end

  def constraint_streifen_nicht_verteilt
    stripes.map { |s| "bool2int(not exists(m in MASCHINEN) (#{s.constraint}))" }.join("\n\t+ ")+";"
  end

  private
  def generate_initiale_loesung
    # 2-D Array der Grösse anzahl_maschinen * anzahl_timeslots erstellen und mit 0 initialisieren
    a = Array.new(@anzahl_maschinen) { Array.new(@anzahl_timeslots, 0) }

    @anzahl_timeslots.times do |ti|
      current_m = 1
      @anzahl_produkte.times do |pi|
        if bedarf[pi][ti]
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

  def generate_initiale_loesung_v2
    @stripes_builder.stripes.sort!.reverse!
    l = Loesung.new(@anzahl_maschinen, anzahl_timeslots)
    begin
      @stripes_builder.stripes.each do |s|
        puts "stripe: #{s.product+1} #{s.size}"
        l.insert s
      end
    rescue => e
      puts e
      p l
      raise ""
    end

    l
  end

  class Loesung
    attr_reader :a

    def initialize anz_maschinen, anz_timeslots
      @a = Array.new(anz_maschinen) { Array.new(anz_timeslots, 0) }
    end

    def insert stripe
      possible = true
      @a.each do |m|
        possible = insert_possible(m, stripe)
        break if possible
      end
      raise "Konnte den Streifen #{stripe.inspect} nicht platzieren" unless possible
    end

    def insert_possible maschine, stripe
      free = true
      (stripe.start_index..stripe.end_index).each do |c_m_i|
        unless maschine[c_m_i] == 0
          free = false
          break
        end
      end
      if free
        (stripe.start_index..stripe.end_index).each { |c_m_i| maschine[c_m_i] = stripe.product+1 }
      end
      free

    end

    def inspect

      @a.map { |m| m.inspect }.join("\n")
    end

  end


end