def find_non_summable_number(int_array, preamble_size)
  preamble = int_array.shift(preamble_size)

  int_array.each do |line|
    return line unless pairs_summing_to_target?(line, preamble)

    preamble.shift
    preamble << line
  end
end

def pairs_summing_to_target?(target, preamble)
  preamble.each do |int|
    return true if preamble.include?(target - int)
  end

  false
end

def find_contiguous_numbers_adding_to_target(int_array, target)
  
  until(int_array.empty?)

    for i in 0..(int_array.length - 1) do
      range = int_array[0..i]
      total_sum = range.reduce(&:+)
      return range if total_sum == target
    end

    int_array.shift
  end

  nil
end

file = File.readlines("input.txt", chomp: true).map(&:to_i)

invalid_number = find_non_summable_number(file.clone, 25)
puts "Puzzle 1: the invalid number is #{invalid_number}"

contiguous_numbers = find_contiguous_numbers_adding_to_target(file.clone, invalid_number)
encryption_weakness = contiguous_numbers.min + contiguous_numbers.max
puts "Puzzle 2: the encryption weakness is #{encryption_weakness}"