class Tile
  attr_accessor :id, :grid, :neighbours

  def initialize(id, grid)
    @id = id
    @grid = grid
    @neighbours = []
  end

  def top_border
    @grid.first.join()
  end

  def bottom_border
    @grid.last.join()
  end

  def left_border
    left_border = ""
    @grid.each do |row|
      left_border += row.first
    end
    left_border
  end

  def right_border
    right_border = ""
    @grid.each do |row|
      right_border += row.last
    end
    right_border
  end

  def all_edge_combinations
    edges = [
      top_border,
      top_border.reverse,
      right_border,
      right_border.reverse,
      bottom_border,
      bottom_border.reverse,
      left_border,
      left_border.reverse,
    ]
  end

  def set_neighbour(other_tile)
    @neighbours << other_tile.id
    @neighbours.uniq!
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
    tile_objects << Tile.new(key, value)
  end

  return tile_objects
end

def find_and_set_neighbours(tile1, tile2)
  matching_edges = tile1.all_edge_combinations & tile2.all_edge_combinations
  return if matching_edges.empty?

  tile1.set_neighbour(tile2)
  tile2.set_neighbour(tile1)
end

def print_tile(tile)
  puts "tile id: #{tile.id}, top_row: #{tile.grid.first}, neighbours: #{tile.neighbours.inspect}"
end

file = File.readlines("input.txt", chomp: true).map(&:strip)
tiles = tiles_from_file(file)

tiles.each do |tile1|
  tiles.each do |tile2|
    next if tile1.id == tile2.id
    find_and_set_neighbours(tile1, tile2)
  end
end

corner_tile_ids = tiles.select { |tile| tile.neighbours.count == 2 }.map { |tile| tile.id.to_i }
result = corner_tile_ids.reduce(&:*)
puts "Result: #{result}"
