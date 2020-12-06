require '../helpers'

groups = ::Helpers.groups_from_file("input.txt")
total_count = 0

groups.each do |group|
  total_count += group.join().chars.uniq.length
end

puts "The total sum is #{total_count}"