def nth_number_in_game_slow(numbers, target)
  while numbers.length < target do
    last_number = numbers.last
    numbers_without_last = numbers[0..(numbers.length - 2)]
    if numbers_without_last.include?(last_number)
      current_index = numbers.length - 1
      previous_index_reverse = numbers_without_last.reverse.index(last_number)
      previous_index = current_index - previous_index_reverse - 1
      numbers << current_index - previous_index
    else
      numbers << 0
    end
  end

  numbers.last
end

def nth_number_in_game(numbers, target)
  numbers_hash = Hash.new([])
  numbers.each_with_index do |number, idx|
    numbers_hash.has_key?(number) ? numbers_hash[number] << idx : numbers_hash[number] = [idx]
  end

  last_number = numbers.last
  numbers_count = numbers.count
  while numbers_count < target do
    current_index = numbers_count - 1
    if numbers_hash[last_number].count == 1
      last_number = 0
    else
      previous_index = numbers_hash[last_number][-2]
      last_number = current_index - previous_index
    end

    numbers_hash.has_key?(last_number) ? numbers_hash[last_number] << current_index + 1 : numbers_hash[last_number] = [current_index + 1]
    numbers_count += 1
  end

  last_number
end

input = [9,12,1,4,17,0,18]
puts "Puzzle 1: #{nth_number_in_game(input, 2020)}"
puts "Puzzle 2: #{nth_number_in_game(input, 30000000)}"
