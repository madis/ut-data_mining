require 'csv'

Iris = Struct.new(:sepal_length, :sepal_width, :petal_length, :petal_width, :species)

def parse_iris_data(file_name, na_value=nil)
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


# http://stackoverflow.com/questions/7749568/how-can-i-do-standard-deviation-in-ruby
module MathHelpers
  def mean
    self.sum / self.count.to_f
  end

  def standard_deviation
    2
  end

  def median
    3
  end

  def min
    4
  end

  def max
    5
  end

  def mode
    6
  end

  def sum
    inject(0) { |accum, i| accum + i }
  end
end

module DataCleaners
  class RemovesRowsWithUnwantedValues
    def initialize(unwanted_values)
      @unwanted_values = unwanted_values
    end

    def call(row)

    end
  end
end

class IrisData
  ColumnNotFound = Class.new(StandardError)

  SETOSA = 'Iris-setosa'
  VERSICOLOR = 'Iris-versicolor'
  VIRGINICA = 'Iris-virginica'

  include Enumerable
  include MathHelpers

  def initialize(csv_table)
    @table = csv_table
  end

  def filter(species)
    self.class.new @table.select { |r| r[:species] == species}
  end

  # Cleans the underlying data by applying
  def clean_rows(&block)
    cleaned = []
    @table.by_row.each do |row|
      cleaned << row if block.call(row)
    end
    self.class.new(CSV::Table.new(cleaned))
  end

  def different_species
  end

  def [](name)
    raise ColumnNotFound.new("#{name.inspect} not among #{headers}") unless headers.include?(name)
    data_column = @table[name]
    data_column.extend(MathHelpers)
    data_column
  end

  def each(&block)
    @table.by_row.each(block)
  end

  def to_s
    counts = Hash[@table.headers.map {|h| [h, 0]}]
    @table.by_row.each do |i|
      i.headers.each {|h| puts "increasing count for #{h}, #{i.inspect} #{counts[i[h]]}"; counts[h] += 1}
    end
    "IrisData species: #{counts}"
  end

  def headers
    @table.headers
  end

end

module Practice4
  class Task1
    def solution
      puts "Solution:\n"
      iris_data_from_files.each_with_index do |data, index|
        puts "File ##{index}"
        clean_data = data.clean_rows { |row|
          decision = !row.fields.include?(nil) && !row.include?('NA')
          puts "Decision for #{row.fields.inspect} : #{decision}"
          decision
        }
        puts "Clean data: #{clean_data}"
        puts calculate_indicators(clean_data)
      end
    end

    def calculate_indicators(iris_data)
      iris_data.headers.map do |header|
        {
          header =>
          {
            mean: iris_data[header].mean,
            standard_deviation: iris_data[header].standard_deviation,
            median: iris_data[header].median,
            min: iris_data[header].min,
            max: iris_data[header].max,
            mode: iris_data[header].mode
          }
        }
      end
    end

    private

    def iris_data_from_files
      files = %w(iris_with_missing_data-1.txt iris_with_missing_data-2.txt)
      files.map { |f| parse_iris_data(f) }.map { |parsed| IrisData.new(parsed) }
    end
  end
end

Practice4::Task1.new.solution
