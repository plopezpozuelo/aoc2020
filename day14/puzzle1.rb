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
  binary_value = value.to_s(2)

  binary_value_reverse = binary_value.reverse
  current_mask.chars.reverse.each_with_index do |bit, idx|
    if idx >= binary_value_reverse.length
      binary_value_reverse += bit == "X" ? "0" : bit
    else
      binary_value_reverse[idx] = bit if bit != "X"
    end
  end

  result_binary_value = binary_value_reverse.reverse
  result_decimal_value = result_binary_value.to_i(2)
  values_hash[address] = result_decimal_value
end

result = values_hash.values.inject(&:+)
puts "Result: #{result}"
