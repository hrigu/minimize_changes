require 'rspec'
require_relative '../../lib/problem'


class Node
  attr_reader :id, :children

  def initialize id
    @id = id
    @children = []
  end

  def add child
    @children << child
  end

  def leave?
    children.empty?
  end

  def to_s
    "#{id}"
  end

  def inspect
    to_s()
  end
end

class Paths
  def initialize
    @paths = []
  end

  def add path
    @paths << path
  end

  def all
    @paths
  end

  def inspect
    @paths.inspect
  end
end

class Graph
  attr_reader :root

  def initialize
    @root = Node.new(0)
  end

  def find_paths
    @paths = Paths.new
    dfs @root, [], true
    @paths
  end

  def dfs node, path, is_root = false
    path = path.dup; puts "dup"
    path << node unless is_root
    if node.leave?
      @paths.add path
    else
      node.children.each_with_index do |c, i|
        dfs(c, path)
      end
    end
  end


end

describe 'FindPaths' do


  describe "." do
    g = Graph.new
    root = g.root

    one = Node.new 1
    two = Node.new 2

    three = Node.new(3)
    four = Node.new(4)

    five = Node.new(5)

    six = Node.new(6)
    seven = Node.new(7)
    eight = Node.new(8)

    root.add one
    root.add two
    one.add three
    one.add four
    two.add three
    two.add four
    four.add(five)
    five.add(six)
    five.add(seven)
    five.add(eight)


    it "works" do
      paths = g.find_paths
      #[[1, 3], [1, 4, 5, 6], [1, 4, 5, 7], [1, 4, 5, 8], [2, 3], [2, 4, 5, 6], [2, 4, 5, 7], [2, 4, 5, 8]]
      # 1456
      # 2457
      # 7
      # 8
      p paths
    end

  end
end
