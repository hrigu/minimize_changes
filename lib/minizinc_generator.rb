require 'erb'
class MinizincGenerator
  def initialize problem, solve_strategy
    @problem, @solve_strategy = problem, solve_strategy
  end

  def render path
    content = File.read(File.expand_path(path))
    t = ERB.new(content)
    t.result(binding)
  end

  def create_mzn_file
    result = render "#{@solve_strategy.template_dir}main.mzn.erb"  #end_variablen_und_gruenorangerot.mzn.erb
    File.open("files/created/created.mzn", 'w+') { |file| file.write(result) }
  end
end
