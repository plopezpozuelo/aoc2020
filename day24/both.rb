def direction_offset(direction)
  return [1, 0] if direction == "e"
  return [0, -1] if direction == "se"
  return [-1, -1] if direction == "sw"
  return [-1, 0] if direction == "w"
  return [0, 1] if direction == "nw"
  return [1, 1] if direction == "ne"
  nil
end

def apply_instructions_from_file(file)
  black_tiles = []
  file.each do |line|
    current_tile = [0, 0]
    line_array = line.chars
    while !line_array.empty? do
      if line_array.first == "w" || line_array.first == "e"
        direction = line_array.shift(1).join
      else
        direction = line_array.shift(2).join
      end

      offset = direction_offset(direction)
      current_tile[0] += offset[0]
      current_tile[1] += offset[1]
    end

    black_tiles.include?(current_tile) ? black_tiles.delete(current_tile) : black_tiles << current_tile
  end

  black_tiles
end

def sum_coords(coord1, coord2)
  result = []
  result << coord1[0] + coord2[0]
  result << coord1[1] + coord2[1]
  result
end

def apply_rules(black_tiles)
  tiles_adjacent_to_black = Hash.new([])
  black_tiles.each do |black_tile|
    tiles_adjacent_to_black[black_tile] = []
  end

  black_tiles.each do |black_tile|
    directions = ["e", "se", "sw", "w", "nw", "ne"]
    directions.each do |direction|
      offset = direction_offset(direction)
      adjacent_tile = sum_coords(black_tile, offset)

      if tiles_adjacent_to_black.has_key?(adjacent_tile)
        tiles_adjacent_to_black[adjacent_tile] << black_tile
      else
        tiles_adjacent_to_black[adjacent_tile] = [black_tile]
      end
    end
  end

  tiles_adjacent_to_black.each do |key, value|
    if black_tiles.include?(key)
      black_tiles.delete(key) if value.count == 0 || value.count > 2
    else
      black_tiles << key if value.count == 2
    end
  end

  black_tiles
end

file = File.readlines("input.txt", chomp: true).map(&:strip)
black_tiles = apply_instructions_from_file(file)
puts "Result 1: there are #{black_tiles.count} black tiles"

100.times do
  black_tiles = apply_rules(black_tiles)
end
puts "Result 2: there are #{black_tiles.count} black tiles"
