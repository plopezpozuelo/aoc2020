require '../helpers'

groups = ::Helpers.groups_from_file("input.txt")
total_count = 0

groups.each do |group|
  total_count += group.map(&:chars).reduce(&:&).count
end

puts "The total sum is #{total_count}"
