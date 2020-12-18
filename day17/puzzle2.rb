def get_active_cubes(filename)
  active_cubes = []
  file = File.readlines(filename, chomp: true).map(&:strip)
  file.each_with_index do |line, x|
    line.chars.each_with_index do |char, y|
      active_cubes << [x,y,0,0] if char == "#"
    end
  end
  active_cubes
end

def sum_cubes(cube1, cube2)
  resulting_cube = []
  cube1.each_with_index do |int, idx|
    resulting_cube << int + cube2[idx]
  end
  resulting_cube
end

def perform_cycle(active_cubes)
  diff_points = [0,1,-1].repeated_permutation(4).to_a
  diff_points.delete([0,0,0,0])
  cubes_adjacent_to_active_cubes = Hash.new([])
  active_cubes.each do |active_cube|
    cubes_adjacent_to_active_cubes[active_cube] = []
  end
  active_cubes.each do |active_cube|
    diff_points.each do |diff|
      adjacent_cube = sum_cubes(active_cube, diff)
      if cubes_adjacent_to_active_cubes.has_key?(adjacent_cube)
        cubes_adjacent_to_active_cubes[adjacent_cube] << active_cube
      else
        cubes_adjacent_to_active_cubes[adjacent_cube] = [active_cube]
      end
    end
  end

  cubes_adjacent_to_active_cubes.each do |key, value|
    if active_cubes.include?(key)
      active_cubes.delete(key) if value.count != 2 && value.count != 3
    else
      active_cubes << key if value.count == 3
    end
  end

  active_cubes
end

active_cubes = get_active_cubes("input.txt")
n = 0
while n < 6
  perform_cycle(active_cubes)
  n += 1
end

puts "Puzzle 2 result: #{active_cubes.count}"
