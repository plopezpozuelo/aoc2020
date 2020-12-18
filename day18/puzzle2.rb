def reduce_for_operator(chunks, operator)
  while chunks.include?(operator) do
    idx = chunks.find_index(operator)
    numeric_result = operator == "+" ? chunks[idx - 1].to_i + chunks[idx + 1].to_i : chunks[idx - 1].to_i * chunks[idx + 1].to_i
    3.times { chunks.delete_at(idx - 1) }
    chunks.insert(idx - 1, numeric_result.to_s)
  end

  chunks
end

def reduce_bracketless_expression(expression)
  expression_chunks = expression.split(" ")

  while expression_chunks.include?("+")
    reduce_for_operator(expression_chunks, "+")
  end

  while expression_chunks.include?("*")
    reduce_for_operator(expression_chunks, "*")
  end

  expression_chunks.first
end

def reduce_expression(expression)
  unless expression.include?("(")
    return reduce_bracketless_expression(expression).to_i
  end

  left_bracket_idx = 0
  right_bracket_idx = 0
  expression.chars.each_with_index do |char, idx|
    if char == "("
      left_bracket_idx = idx
    elsif char == ")"
      right_bracket_idx = idx
      break
    end
  end

  single_bracket_expression = expression.slice!(left_bracket_idx..right_bracket_idx)
  expression.insert(left_bracket_idx, reduce_bracketless_expression(single_bracket_expression[1..-2]))
  reduce_expression(expression)
end

file = File.readlines("input.txt", chomp: true).map(&:strip)
result = 0
file.each do |line|
  result += reduce_expression(line)
end

puts "Result: #{result}"
