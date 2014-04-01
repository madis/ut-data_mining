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
