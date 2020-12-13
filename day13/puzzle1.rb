file = File.readlines('input.txt', chomp: true).map(&:strip)
time_ready = file[0].to_i
timetable = file[1].split(',')
timetable.delete('x')
timetable = timetable.map(&:to_i)

time_until_next_bus_hash = timetable.map{ |bus| { bus => bus - (time_ready % bus) } }

time_until_next_bus_hash = Hash.new()
timetable.each do |bus|
  time_until_next_bus_hash[bus] = bus - (time_ready % bus)
end

sorted = time_until_next_bus_hash.sort_by {|key, value| value}
next_bus = sorted.first[0]
time_to_wait = sorted.first[1]

puts "Result: #{next_bus*time_to_wait}"