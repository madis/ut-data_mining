require 'forwardable'

class Cluster
  extend Forwardable
  def_delegators :@center, :x, :y
  def_delegator :@members, :<<
  def_delegator :@members, :include?

  attr_reader :center, :members

  def self.with_center(x, y)
    new(Point.new(x, y))
  end

  def initialize(center_point=nil)
    @center = center_point
    @members = []
  end

  # Recalculates center based on members.
  # Returns true if center changed, false if center stayed the same
  def recalculate_center
    debug { puts "Calculating center for: #{self}" }
    if @members.empty?
      false
    else
      new_center_x = (@members.dup << @center).inject(0.0) { |result, member| result += member.x } / (members.size + 1)
      new_center_y = (@members.dup << @center).inject(0.0) { |result, member| result += member.y } / (members.size + 1)
      debug { puts "Got new center: x = #{new_center_x} y = #{new_center_y}" }
      new_center = Point.new(new_center_x, new_center_y)
      changed = new_center != @center
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

  def inspect
    to_s
  end

  def pretty
    "Cluster:   #{self.center} \n  Members: #{self.members}"
  end

  def ==(other)
    return false unless other.respond_to?(:center) && other.respond_to?(:members)
    center == other.center && members == other.members
  end
end
