#!/usr/bin/env ruby
require_relative '../lib/point'
require_relative '../lib/cluster'

DEBUGGING_ENABLED = false
def debug
  yield if DEBUGGING_ENABLED
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

    until cluster_centers_stayed_the_same?(clusters)
      clusters.each(&:flush_members)
      @points.each do |point|
        closest_cluster = @distance.call(point, clusters)
        closest_cluster << point
      end
    end
    clusters
  end

  private

  def cluster_centers_stayed_the_same?(clusters)
    # Recalculate returns true when center changed so checking here that it
    # was not true for any of the clusters meaning that none whas changed.
    changed = clusters.none? { |c| c.recalculate_center }
    debug { puts "same? #{same}" }
    !changed
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
  puts cluster.pretty
end

def random_float
  rand(-10..10) + rand(0..9) * 0.1
end

# Searching for other initial centers that would produce different results
different_clustering_results = {}
until different_clustering_results.size >= 3
  random_starting_centers = 3.times.map {|n| Cluster.with_center(random_float, random_float)}
  new_clustering = KMeansClustering.new(data_points.values, random_starting_centers, finds_closest_by_minimum_eucledian_distance).cluster
  if new_clustering != clusters
    different_clustering_results[random_starting_centers] = new_clustering
  end
end

puts "Task 2\n--------"
puts "Got 3 new clusterings that are different from the original:"
different_clustering_results.each do |start, clusters|
  puts "Starting: #{start}"
  clusters.each { |c| puts c.pretty }
end
