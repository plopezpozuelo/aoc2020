file = File.readlines('input.txt', chomp: true).map(&:strip)

values_hash = Hash.new(0)
current_mask = []
file.each do |line|
  if line.include?("mask")
    current_mask = line.gsub("mask = ", "")
    next
  end

  address, value = line.split(" = ")
  address = address.gsub("mem[", "").gsub("]", "").to_i
  value = value.to_i
  binary_address = address.to_s(2)

  binary_address_reverse = binary_address.reverse
  current_mask.chars.reverse.each_with_index do |bit, idx|
    if idx >= binary_address_reverse.length
      binary_address_reverse += bit
    else
      binary_address_reverse[idx] = bit if bit != "0"
    end
  end
  result_binary_address = binary_address_reverse.reverse

  number_of_digits_in_permutations = result_binary_address.count('X')
  number_of_permutations = 2 ** number_of_digits_in_permutations
  all_address_combinations = []
  [*0..(number_of_permutations - 1)].each do |int|
    binary_digits = int.to_s(2)
    while binary_digits.length < number_of_digits_in_permutations
      binary_digits = '0' + binary_digits
    end

    address_combination = result_binary_address.dup
    binary_digits.chars.each do |digit|
      index_to_replace = address_combination.index('X')
      address_combination[index_to_replace] = digit
      all_address_combinations << address_combination
    end
  end

  all_address_combinations.each do |address|
    decimal_address = address.to_i(2)
    values_hash[address] = value
  end
end

result = values_hash.values.inject(&:+)
puts "Result: #{result}"
