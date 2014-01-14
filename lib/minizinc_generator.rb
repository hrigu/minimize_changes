require 'erb'
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
