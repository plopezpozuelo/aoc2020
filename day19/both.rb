def messages(file)
  messages = []
  file.each do |line|
    next if line.include?(":") || line.empty?

    messages << line
  end
  messages
end

def rules_hash(file)
  rules_hash = Hash.new()
  file.each do |line|
    break unless line.include?(":")

    key, value = line.split(": ")
    if value.include?('"')
      value = value.delete("\"")
    else
      value = value.split("|").map { |v| v.split().map(&:to_i) }
    end

    rules_hash[key.to_i] = value
  end

  rules_hash
end

def message_abides_to_rules?(message, rules, rules_hash)
  return true if message.empty? && rules.empty?
  return false if message.empty? || rules.empty?

  first_rule = rules_hash[rules.first]
  if first_rule.is_a?(String)
    return false unless first_rule.include?(message[0])
    return message_abides_to_rules?(message[1..-1], rules[1..-1], rules_hash)
  else
    first_rule.each do |term|
      return true if message_abides_to_rules?(message, term + rules[1..-1], rules_hash)
    end
  end

  false
end

file1 = File.readlines("input1.txt", chomp: true).map(&:strip)
rules_hash = rules_hash(file1)
messages = messages(file1)
result1 = messages.count { |message| message_abides_to_rules?(message, [0], rules_hash) }
puts "Puzzle 1: there are #{result1} messages that match the rules"

file2 = File.readlines("input2.txt", chomp: true).map(&:strip)
rules_hash = rules_hash(file2)
messages = messages(file2)
result2 = messages.count { |message| message_abides_to_rules?(message, [0], rules_hash) }
puts "Puzzle 2: there are #{result2} messages that match the rules"
