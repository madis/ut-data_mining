#!/usr/bin/env ruby

require 'bundler'
Bundler.setup
require 'rgl/adjacency'

class Edge
  def initialize(from, to)
    @from = from
    @to = to
  end
end

class Node
  def initialize(id)
    @id = id
    @data = data
    @to = []
  end

  def <<(node)
    @to << node
  end

  def find(id)
    if id == @id
      self
    elsif @to.count > 0
      @to.find {|n| n.find(id) }
    else
      nil
    end
  end

  def to_s
    "Node #{@id} (#{@to})"
  end

  def inspect
    to_s
  end
end

class Graph
  def initialize
    @nodes = []
  end

  def add_vertex(from, to)
    # puts "Adding #{from} -> #{to} #{self}"
    node = @nodes.find(->{ n = Node.new(from); @nodes << n; n }) do |node|
      node.find(from)
    end
    node << Node.new(to)
  end

  def to_s
    @nodes.join('\n').to_s
  end

  def inspect
    to_s
  end

  def [](node_id)
    @nodes.find(node_id)
  end
end

COMMENT = '#'

graph = Graph.new
counter = 0

def data_lines
  return unless block_given?
  file = File.open('email_virus.txt')
  file.each_line do |line|
    if line[0] == COMMENT
      next
    else
      yield(*line.split.map(&:to_i))
    end
  end
end

require 'set'

def count_nodes
  node_set = Set.new
  data_lines do |from, to|
    node_set << from
    node_set << to
  end
  node_set.size
end

def count_edges
  counter = 0
  data_lines { |from, to| counter += 1 }
  counter
end

def count_self_loops
  self_loop_count = 0
  data_lines { |from, to| self_loop_count += 1 if from == to }
  self_loop_count
end

def count_reciprocated_edges
  inspected_edges = Set.new
  count = 0
  data_lines do |from, to|
    count += 1 if inspected_edges.include?([to, from])
    inspected_edges << [from, to]
  end
  count
end

def count_disconnected_nodes

end

puts "nodes count: #{count_nodes}"
puts "edges count: #{count_edges}"
puts "self loop count: #{count_self_loops}"
puts "reciprocated edges: #{count_reciprocated_edges}"
puts "number of disconnected nodes #{count_disconnected_nodes}"

# Task 5: real world model
class City < Node
  def initialize(id, name)
    super(id)
    @name = name
  end
end

class Road < Edge
  def initialize(from, to, type)
    super(from, to)
    @type = type
  end
end

class RoadNetworkGenerator
  ROAD_TYPES = [:highway, :regular, :dirt]

  def initialize(cities_count, road_quality, average_distance)
    @cities_count = cities_count
    @road_quality = road_quality
    @average_distance = average_distance
  end

  def generate
    @road_network = Graph.new
    add_cities
    add_roads
    @road_network
  end

  private

  def add_cities
    @cities_count.times { |n| @road_network << City.new(n, "City ##{n}") }
  end

  def add_roads
    first, second = pick_random_cities
    road_type = pick_probable_road
    @road_network.add_edge(Road.new(first, second, road_type, road_length))
  end

  def pick_random_cities
    [@road_network[rand(cities_count)], @road_network[rand(cities_count)]]
  end

  def pick_probable_road
    ROAD_TYPES[rand(ROAD_TYPES.count)*@road_quality]
  end

  def road_length
    gaussian_rand(@average_distance, @average_distance*0.5, rand)
  end

  def gaussian_rand(mean, stddev, rand)
    theta = 2 * Math::PI * rand.call
    rho = Math.sqrt(-2 * Math.log(1 - rand.call))
    scale = stddev * rho
    x = mean + scale * Math.cos(theta)
    y = mean + scale * Math.sin(theta)
    return x, y
  end
end

