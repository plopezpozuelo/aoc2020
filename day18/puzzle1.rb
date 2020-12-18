def result_for_expression(chunks)
  while chunks.count > 1 do
    idx = 2
    while idx < chunks.count do
      if !chunks[idx - 2].include?(")") && (chunks[idx - 1] == "*" || chunks[idx - 1] == "+") && !chunks[idx].include?("(")
        left_brackets = chunks[idx - 2].tr("0-9", "")
        left_number = (chunks[idx - 2].chars - ["("]).join.to_i
        right_brackets = chunks[idx].tr("0-9", "")
        right_number = (chunks[idx].chars - [")"]).join.to_i
        operation = chunks[idx - 1]

        numeric_result = operation == "+" ? left_number + right_number : left_number * right_number
        chunked_result = left_brackets + numeric_result.to_s + right_brackets
        3.times { chunks.delete_at(idx - 2) }
        chunks.insert(idx - 2, chunked_result)
        remove_redundant_brackets(chunks)
        break
      end
      idx += 1
    end
  end
  chunks.first.to_i
end

def remove_redundant_brackets(string)
  string.each_with_index do |chunk, idx|
    next unless chunk.include?("(") && chunk.include?(")")
    string[idx] = chunk.sub("(", "").sub(")", "")
  end
end

file = File.readlines("input.txt", chomp: true).map(&:strip)
result = 0
file.each do |line|
  result += result_for_expression(line.split(" "))
end

puts "Result: #{result}"
