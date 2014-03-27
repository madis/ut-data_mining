#!/usr/bin/env ruby

require 'csv'

Iris = Struct.new(:sepal_length, :sepal_width, :petal_length, :petal_width, :species)

def parse_exercise_data(file_name, na_value=nil)
  CSV::Converters[:na_to_nil] = ->(s) { s == 'NA' ? na_value : s}
  options = {
    col_sep: ' ',
    converters: [:numeric, :na_to_nil],
    headers: true,
    header_converters: :symbol
  }
  iris_rows = []
  CSV.read(file_name, options).by_col
end

# Read data from the file, data.txt, calculate mean and variance for every
# feature (column). Compute correlation between pairs of features x1 vs y1, x2
# vs y2 etc. Compare results. Plot each of these pairs separately (such that x
# feature is on the x-axis and y feature on the y-axis). Interpret the
# results.
class Task3
  def mean
  end

  def variance
  end

  def
end
