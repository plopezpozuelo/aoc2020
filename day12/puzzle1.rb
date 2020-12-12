class Position
  attr_accessor :north, :east, :facing

  def initialize(north, east, facing)
    @north = north
    @east = east
    @facing = facing
  end

  def move(direction, distance)
    case direction
    when "N"
      @north += distance
    when "E"
      @east += distance
    when "S"
      @north -= distance
    when "W"
      @east -= distance
    end
  end

  def rotate(direction, degrees)
    directions = ["N", "E", "S", "W"]

    if degrees == 180
      new_index = (directions.find_index(@facing) + 2) % 4
    elsif (degrees == 90 && direction == 'R') || (degrees == 270 && direction == 'L')
      new_index = (directions.find_index(@facing) + 1) % 4
    elsif (degrees == 270 && direction == 'R') || (degrees == 90 && direction == 'L')
      new_index = (directions.find_index(@facing) - 1) % 4 
    end

    @facing = directions[new_index] if new_index
  end
end

instructions = File.readlines("input.txt", chomp: true).map(&:strip)
position = Position.new(0, 0, "E")

instructions.each do |inst|
  direction = inst[0]
  magnitude = inst[1..-1].to_i

  case direction
  when "N", "E", "S", "W"
    position.move(direction, magnitude)
  when "F"
    position.move(position.facing, magnitude)
  when "L", "R"
    position.rotate(direction, magnitude)
  end
end

manhattan_distance = position.north.abs + position.east.abs
puts "Result: #{manhattan_distance}"
