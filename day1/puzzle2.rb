def find_triplet_summing_to_target(number_array, target)
  number_array.each_with_index do |number1, index|
    number_array[(index+1)..].each do |number2|
      number3 = target - number2 - number1
      next unless number_array.include?(number3)

      return number1, number2, number3
    end
  end
end

number_array = File.readlines("input.txt").map(&:to_i)
number1, number2, number3 = find_triplet_summing_to_target(number_array, 2020)
puts number1*number2*number3