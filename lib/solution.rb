class Solution
  def initialize solution_string
    @solution_string = solution_string
  end

  def parse
    zuweisungen = @solution_string.split(";")
    x = zuweisungen.map{|x|
      a = x.scan(/\d+/)
      a.map(&:to_i)
    }

    x = x.delete_if {|x| x.size != 3 }
    m_max = x.max_by{|m| m[0]}[0]
    t_max = x.max_by{|m| m[1]}[1]

    @solution_array = Array.new()
    m_max.times do |i|
      @solution_array << Array.new(t_max, 0)
    end

    x.each do |y|
      m = y[0]-1
      t = y[1]- 1
      @solution_array[m][t]= y[2]
    end

  end

  def print_solution
    s = ""
    @solution_array.each do |m|
      m.each do |t|
        s+= t > 0 ? t.to_s : "."
        s+= t < 10 ? " ": ""
      end
      s += "\n"
    end
    puts s
  end

end