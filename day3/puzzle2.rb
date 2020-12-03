@file = File.readlines("input.txt")
@columns_count = @file.first.strip.length

def trees_encountered(steps_right, steps_down)
  trees_count = 0
  column_to_check = 0

  @file.each_with_index do |line, index|
    next unless (index % steps_down).zero?

    trees_count += 1 if line[column_to_check] == '#'
    column_to_check = (column_to_check + steps_right) % @columns_count
  end

  return trees_count
end

trees_slope_1 = trees_encountered(1, 1)
trees_slope_2 = trees_encountered(3, 1)
trees_slope_3 = trees_encountered(5, 1)
trees_slope_4 = trees_encountered(7, 1)
trees_slope_5 = trees_encountered(1, 2)
result = trees_slope_1*trees_slope_2*trees_slope_3*trees_slope_4*trees_slope_5

puts "You encountered #{trees_slope_1} trees on the first slope"
puts "You encountered #{trees_slope_2} trees on the second slope"
puts "You encountered #{trees_slope_3} trees on the third slope"
puts "You encountered #{trees_slope_4} trees on the fourth slope"
puts "You encountered #{trees_slope_5} trees on the fifth slope"
puts "Multiplying them all together: #{result}"