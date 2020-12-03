file = File.readlines("input.txt")

trees_count = 0
column_to_check = 0
columns_count = file.first.strip.length

file.each do |line|
  trees_count += 1 if line[column_to_check] == '#'
  column_to_check = (column_to_check + 3) % columns_count
end

puts "You encountered #{trees_count} trees"