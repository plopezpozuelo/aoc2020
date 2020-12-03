def find_pair_summing_to_target(number_array, target)
  number_array.each do |number|
    desired_number = target - number
    next unless number_array.include?(desired_number)

    return number, desired_number
  end
end

number_array = File.readlines("input.txt").map(&:to_i)
number1, number2 = find_pair_summing_to_target(number_array, 2020)
puts number1*number2