#!/usr/bin/env ruby

require_relative '../lib/point'
require_relative '../lib/cluster'

class Point
  attr_writer :visited, :noise

  def noise?
    !!@noise
  end

  def visited?
    !!@visited
  end

  def unvisited?
    !@visited
  end
end


class Cluster
end
# Use already well-studied example dataset from two previous homeworks and
# apply DBSCAN using eps = 2, MinPts = 2. Declare, which points are noise,
# border and core points.
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

MIN_POINTS = 2
EPS = 2

# DBSCAN(D, eps, MinPts)
#    C = 0
#    for each unvisited point P in dataset D
#       mark P as visited
#       NeighborPts = regionQuery(P, eps)
#       if sizeof(NeighborPts) < MinPts
#          mark P as NOISE
#       else
#          C = next cluster
#          expandCluster(P, NeighborPts, C, eps, MinPts)

# expandCluster(P, NeighborPts, C, eps, MinPts)
#    add P to cluster C
#    for each point P' in NeighborPts
#       if P' is not visited
#          mark P' as visited
#          NeighborPts' = regionQuery(P', eps)
#          if sizeof(NeighborPts') >= MinPts
#             NeighborPts = NeighborPts joined with NeighborPts'
#       if P' is not yet member of any cluster
#          add P' to cluster C

# regionQuery(P, eps)
#    return all points within P's eps-neighborhood (including P)


class Dbscan
  def initialize(points, eps, min_distance)
    @points = points
    @eps = eps
    @min_distance = min_distance
  end

  def cluster
    clusters = []

    @points.each do |point|
      point.visited = true
      neighbours = find_neighbours(point)
      if neighbours.size < MIN_POINTS
        point.noise = true
      else
        cluster = Cluster.new
        expand_cluster(point, neighbours, cluster, clusters, @points)
        clusters << cluster
      end
    end
    clusters
  end

  private

  def find_neighbours(original_point)
    @points.find_all do |point|
      original_point.distance(point) <= EPS
    end
  end

  def not_member_of_any_cluster?(point, clusters)
    clusters.all? { |c| !c.include?(point) }
  end

  def expand_cluster(point, neighbours, cluster, clusters, data_points)
    cluster << point
    neighbours.each do |neighbour|
      if neighbour.unvisited?
        neighbour.visited = true
        second_neighbours = find_neighbours(neighbour)
        if second_neighbours.count  >= MIN_POINTS
          neighbours += second_neighbours
        end
      end
      cluster << neighbour if not_member_of_any_cluster?(neighbour, clusters)
    end
  end

end

puts "Clusters: "
Dbscan.new(data_points.values, EPS, MIN_POINTS).cluster.each { |c| puts c }
