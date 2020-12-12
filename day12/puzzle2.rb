class Position
  attr_accessor :north, :east

  def initialize(north, east)
    @north = north
    @east = east
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

  def rotate_around_origin(direction, degrees)
    current_north = @north
    current_east = @east

    if degrees == 180
      @north = -current_north
      @east = -current_east
    elsif (degrees == 90 && direction == 'R') || (degrees == 270 && direction == 'L')
      @east = current_north
      @north = -current_east
    elsif (degrees == 270 && direction == 'R') || (degrees == 90 && direction == 'L')
      @east = -current_north
      @north = current_east
    end
  end
end

instructions = File.readlines("input.txt", chomp: true).map(&:strip)

ship_position = Position.new(0, 0)
waypoint_position = Position.new(1, 10)

instructions.each do |inst|
  direction = inst[0]
  magnitude = inst[1..-1].to_i

  case direction
  when "N", "E", "S", "W"
    waypoint_position.move(direction, magnitude)
  when "F"
    ship_position.move("N", magnitude * waypoint_position.north)
    ship_position.move("E", magnitude * waypoint_position.east)
  when "L", "R"
    waypoint_position.rotate_around_origin(direction, magnitude)
  end
end

manhattan_distance = ship_position.north.abs + ship_position.east.abs
puts "Result: #{manhattan_distance}"
