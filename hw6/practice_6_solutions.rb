#!/usr/bin/env ruby
require 'forwardable'

DEBUGGING_ENABLED = false
def debug
  yield if DEBUGGING_ENABLED
end

class Point < Struct.new(:x, :y)

  def distance(other_point)
    Math.sqrt( (x - other_point.x)**2 + (y - other_point.y)**2)
  end

  def ==(other)
    return false unless other.respond_to?(:x) && other.respond_to?(:y)
    x == other.x && y == other.y
  end

  def to_s
    "(#{x},#{y})"
  end

  def inspect
    to_s
  end
end

class Cluster
  extend Forwardable
  def_delegators :@center, :x, :y
  def_delegator :@members, :<<
  attr_reader :center, :members

  def self.with_center(x, y)
    new(Point.new(x, y))
  end

  def initialize(center_point)
    @center = center_point
    @members = []
  end

  # Recalculates center based on members.
  # Returns true if center changed, false if center stayed the same
  def recalculate_center
    debug { puts "Calculating center for: #{self}" }
    if @members.empty?
      @center = center
      false
    else
      new_center_x = (@members.dup << @center).inject(0.0) { |result, member| result += member.x } / (members.size + 1)
      new_center_y = (@members.dup << @center).inject(0.0) { |result, member| result += member.y } / (members.size + 1)
      debug { puts "Got new center: x = #{new_center_x} y = #{new_center_y}" }
      new_center = Point.new(new_center_x, new_center_y)
      changed = new_center == center
      @center = new_center
      changed
    end
  end

  def flush_members
    @members = []
  end

  def to_s
    "<Cluster center=#{@center} members=#{@members}>"
  end

  def ==(other)
    return false unless other.respond_to?(:center) && other.respond_to?(:members)
    center == other.center && members == other.members
  end
end

class KMeansClustering
  def initialize(points, centers, distance)
    @points = points
    @centers = centers
    @distance = distance
  end

  def cluster
    # http://insideintercom.io/machine-learning-way-easier-than-it-looks/
    clusters = @centers
    clusters_stable = false

    def cluster_centers_stayed_the_same?(clusters)
      same = clusters.all? { |c| c.recalculate_center }
      debug { puts "same? #{same}" }
      same
    end

    until cluster_centers_stayed_the_same?(clusters)
    # 10.times do
      clusters.each(&:flush_members)
      @points.each do |point|
        closest_cluster = @distance.call(point, clusters)
        closest_cluster << point
      end
    end
    clusters
  end
end

data_points = {
  a: Point.new(2, 4),
  b: Point.new(7, 3),
  c: Point.new(3, 5),
  d: Point.new(5, 3),
  e: Point.new(7, 4),
  f: Point.new(6, 8),
  g: Point.new(6, 5),
  h: Point.new(8, 4),
  i: Point.new(2, 5),
  j: Point.new(3, 7)
}
initial_clusters = [Cluster.with_center(2,6), Cluster.with_center(2,8), Cluster.with_center(5,8)]
finds_closest_by_minimum_eucledian_distance = ->(point, pool) { pool.min_by { |e| point.distance(e) } }

clusters = KMeansClustering.new(data_points.values, initial_clusters, finds_closest_by_minimum_eucledian_distance).cluster

elements_in_clusters = clusters.inject(0) { |sum, c| sum += c.members.count }
clusters.each do |cluster|
  puts "Cluster:   #{cluster.center} \n  Members: #{cluster.members}"
end
