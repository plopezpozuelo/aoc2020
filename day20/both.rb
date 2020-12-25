class Tile
  attr_accessor :id, :grid, :top_neighbour, :right_neighbour, :bottom_neighbour, :left_neighbour

  def initialize(id, grid)
    @id = id
    @grid = grid
    @top_neighbour = nil
    @right_neighbour = nil
    @bottom_neighbour = nil
    @left_neighbour = nil
  end

  def top_border
    @grid.first
  end

  def bottom_border
    @grid.last
  end

  def left_border
    left_border = ""
    @grid.each do |row|
      left_border += row[0]
    end
    left_border
  end

  def right_border
    right_border = ""
    @grid.each do |row|
      right_border += row[-1]
    end
    right_border
  end

  def flip!
    @grid.reverse!
  end

  def rotate!
    @grid = @grid.map{ |row| row.chars }.transpose.map(&:reverse).map(&:join)
  end

  def has_neighbours?
    return false if @top_neighbour.nil? && @right_neighbour.nil? && @bottom_neighbour.nil? && @left_neighbour.nil?
    true
  end

  def neighbour_count
    count = 4
    count -= 1 if @top_neighbour.nil?
    count -= 1 if @right_neighbour.nil?
    count -= 1 if @bottom_neighbour.nil?
    count -= 1 if @left_neighbour.nil?
    count
  end

  def neighbours
    [@top_neighbour, @right_neighbour, @bottom_neighbour, @left_neighbour].reject(&:nil?)
  end

  def borderless
    @grid[1..-2].map { |row| row[1..-2] }
  end
end

def tiles_from_file(file)
  tile_hash = {}
  tile_id = 0
  file.each do |line|
    next if line.empty?

    if line.include?("Tile")
      tile_id = line.gsub("Tile ", "").gsub(":", "")
      tile_hash[tile_id] = []
      next
    end

    tile_hash[tile_id] << line.chars
  end

  tile_objects = []
  tile_hash.each do |key, value|
    tile_objects << Tile.new(key, value.map(&:join))
  end

  return tile_objects
end

def find_and_set_neighbours(tile1, tile2)
  if tile1.top_border == tile2.bottom_border
    tile1.top_neighbour = tile2
    tile2.bottom_neighbour = tile1
    return true
  elsif tile1.bottom_border == tile2.top_border
    tile1.bottom_neighbour = tile2
    tile2.top_neighbour = tile1
    return true
  elsif tile1.right_border == tile2.left_border
    tile1.right_neighbour = tile2
    tile2.left_neighbour = tile1
    return true
  elsif tile1.left_border == tile2.right_border
    tile1.left_neighbour = tile2
    tile2.right_neighbour = tile1
    return true
  end
  return false
end

def print_tile(tile)
  puts "tile id: #{tile.id}, top_row: #{tile.grid.first}, bottom_row: #{tile.grid.last}, top: #{tile.top_neighbour&.id}, right: #{tile.right_neighbour&.id}, bottom: #{tile.bottom_neighbour&.id}, left: #{tile.left_neighbour&.id}"
end

def find_neighbours(tile, all_tiles)
  existing_neighbours = tile.neighbours
  all_tiles.each do |other_tile|
    break if tile.neighbour_count == 4
    next if tile.id == other_tile.id
    next if find_and_set_neighbours(tile, other_tile)
    next if other_tile.has_neighbours?

    4.times do
      other_tile.flip!
      break if find_and_set_neighbours(tile, other_tile)

      other_tile.flip!
      other_tile.rotate!
      break if find_and_set_neighbours(tile, other_tile)
    end
  end

  new_found_neighbours = tile.neighbours - existing_neighbours
  new_found_neighbours.each do |new_neighbour|
    find_neighbours(new_neighbour, all_tiles)
  end
end

def build_map(tiles)
  upper_left_corner = tiles.detect { |tile| tile.top_neighbour.nil? && tile.left_neighbour.nil? }
  map = build_map_row(upper_left_corner)
  bottom_most_tile = upper_left_corner
  while bottom_most_tile.bottom_neighbour do
    bottom_most_tile = bottom_most_tile.bottom_neighbour
    new_row = build_map_row(bottom_most_tile)
    map << new_row
  end
  map.flatten
end

def build_map_row(left_most_tile)
  map_row = left_most_tile.borderless
  while left_most_tile.right_neighbour do
    left_most_tile = left_most_tile.right_neighbour
    borderless_tile = left_most_tile.borderless
    map_row.each_with_index do |row, idx|
      map_row[idx] = row + borderless_tile[idx]
    end
  end

  map_row
end

def hash_count(grid)
  hash_count = 0
  grid.each do |row|
    hash_count += row.count("#")
  end
  hash_count
end

def sea_monster_count(map)
  monster_hash_indices = []
  SEA_MONSTER.each_with_index do |row, row_idx|
    row.chars.each_index do |col_idx|
      next if SEA_MONSTER[row_idx][col_idx] != '#'
      monster_hash_indices << [row_idx, col_idx]
    end
  end

  rows_to_check = map.length - SEA_MONSTER.length
  cols_to_check = map.first.length - SEA_MONSTER.first.length
  monster_count = 0
  [*0..rows_to_check].each do |row|
    [*0..cols_to_check].each do |col|
      monster_found = true

      monster_hash_indices.each do |monster_row, monster_col|
        if map[row + monster_row][col + monster_col] != "#"
          monster_found = false
          break
        end
      end

      monster_count += 1 if monster_found
    end
  end

  monster_count
end

def find_sea_monster_count(map)
  count = sea_monster_count(map)
  while count.zero?
    map.reverse!
    count = sea_monster_count(map)
    next unless count.zero?

    map.reverse!
    map = map.map{ |row| row.chars }.transpose.map(&:reverse).map(&:join)
    count = sea_monster_count(map)
  end

  count
end

file = File.readlines("input.txt", chomp: true).map(&:strip)
tiles = tiles_from_file(file)
find_neighbours(tiles.first, tiles)
corner_tile_ids = tiles.select { |tile| tile.neighbours.count == 2 }.map { |tile| tile.id.to_i }
result1 = corner_tile_ids.reduce(&:*)
puts "Puzzle 1: #{result1}"

SEA_MONSTER = [
  "                  # ",
  "#    ##    ##    ###",
  " #  #  #  #  #  #   ",
]

map = build_map(tiles)
map_hashes = hash_count(map)
sea_monster_hashes = hash_count(SEA_MONSTER)
sea_monster_count = find_sea_monster_count(map)
result = map_hashes - (sea_monster_count * sea_monster_hashes)
puts "Puzzle 2: #{result}"
