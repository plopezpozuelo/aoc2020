def puzzle1(joltages)
  difference_of_1_count = 0
  difference_of_3_count = 0

  joltages.each_with_index do |joltage, idx|
    next if idx == joltages.length - 1

    difference = joltages[idx + 1] - joltage
    difference_of_1_count += 1 if difference == 1
    difference_of_3_count += 1 if difference == 3
  end

  result = difference_of_1_count * difference_of_3_count
  puts "Result: #{result}"
end

def puzzle2(joltages)
  arrangements = Hash.new(0)
  arrangements[0] = 1

  joltages.each do |joltage|
    [1, 2, 3].each do |diff|
      arrangements[joltage + diff] += arrangements[joltage] if joltages.include?(joltage)
    end
  end

  result = arrangements[joltages.last]
  puts "Result: #{result}"
end

joltages = File.readlines("input.txt", chomp: true).map(&:to_i).sort
joltages = [0] + joltages + [joltages.last + 3]
puzzle1(joltages)
puzzle2(joltages)
