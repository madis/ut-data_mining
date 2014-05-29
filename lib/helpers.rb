require 'matrix'

record_ratings = {
  'Blues Traveler' => [3.5, 2, 5, 3, nil, nil, 5, 3],
  'Broken Bells' => [2, 3.5, 1, 4, 4, 4.5, 2, nil],
  'Deadmau5' => [nil, 4, 1, 4.5, 1, 4, nil, nil],
  'Norah Jones' => [4.5, nil, 3, nil, 4, 5, 3, 5],
  'Phoenix' => [5, 2, 5, 3, nil, 5, 5, 4],
  'Slightly Stoopid' => [1.5, 3.5, 1, 4.5, nil, 4.5, 4, 2.5],
  'The Strokes' => [2.5, nil, nil, 4, 4, 4, 5, 3],
  'Vampire Weekend' => [2, 3, nil, 2, 1, 4, nil, nil]
}

module Helpers
  def pearson_correlation_coefficient(x_values, y_values)
    PearssonCorrelationCoeficcient.new(x_values, y_values).calculate
  end

  def cosine_similarity(x_values, y_values)

  end

  def adjusted_cosine_similarity(x_values, y_values)
    # Subtract user's average rating from his rating to counter grade inflation
  end

  def manhattan_distance(ratings_a, ratings_b)
    ManhattanDistance.from_vectors(ratings_a, ratings_b)
  end

  def eucleidian_distance(ratings_a, ratings_b)
    EuclideanDistance.from_vectors(ratings_a, ratings_b)
  end

  def minkowski_distance(ratings_a, ratings_b, order)
    MinkowskiDistance.from_arrays(ratings_a, ratings_b, order)
  end
end


class ManhattanDistance
  NonVectorPassed = Class.new(ArgumentError)

  def self.from_vectors(first, second)
    throw ArgumentError unless first.is_a(Vector) && second.is_a?(Vector)
    (first - second).inject(0) {|sum,c| sum += c.abs}
  end

  def self.from_arrays(first, second)
    first.zip(second).inject(0) { |sum, ratings| sum += (ratings[0] - ratings[1]).abs }
  end
end

class EuclideanDistance
  def self.from_vectors(first, second)
    (first - second).magnitude
  end

  def self.from_arrays

  end
end

class MinkowskiDistance
  def self.from_arrays(first, second, order)
    first.zip(second).inject(0.0) { |sum, e| sum += ((e[0] - e[1]).abs ** order) } ** (1/order)
  end
end

class PearsonCorrelationCoeficcient
  def initialize(x_values, y_values)
    @x_values = x_values
    @y_values = y_values
  end

  # http://en.wikipedia.org/wiki/Pearson_product-moment_correlation_coefficient
  def calculate
    (multiplied_xy_sum - (sum_x * sum_y) / count) /  (standard_deviation_x * standard_deviation_y)
  end

  private

  def standard_deviation_x
    (sum_x_squared - sum_x**2 / count) ** 0.5
  end

  def standard_deviation_y
    (sum_y_squared - sum_y**2 / count) ** 0.5
  end

  def count
    @x_values.count
  end

  def multiplied_xy_sum
    @x_values.zip(@y_values).map { |xy| xy[0] * xy[1] }.reduce(&:+)
  end

  def sum_x
    @x_values.reduce(&:+)
  end

  def sum_y
    @y_values.reduce(&:+)
  end

  def sum_x_squared
    @x_values.reduce(0) { |sum, x| sum += x**2 }
  end

  def sum_y_squared
    @y_values.reduce(0) { |sum, x| sum += x**2 }
  end
end
