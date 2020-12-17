class Rule
  attr_accessor :name
  def initialize(name, ranges)
    @name = name
    @ranges = ranges
  end

  def is_valid?(number)
    @ranges.each do |range|
      min, max = range.split("-").map(&:to_i)
      return true if number >= min && number <= max
    end
    false
  end
end

def create_rule_objects(filename)
  file = File.readlines(filename, chomp: true).map(&:strip)
  rule_objects = []
  file.each do |line|
    name, ranges = line.split(": ")
    rule_objects << Rule.new(name, ranges.split(" or "))
  end
  rule_objects
end

def get_tickets(filename)
  file = File.readlines(filename, chomp: true).map(&:strip)
  tickets = []
  file.each do |line|
    tickets << line.split(",").map(&:to_i)
  end
  tickets
end

def error_rate(rules, nearby_tickets)
  error_rate = 0
  nearby_tickets.each do |ticket|
    ticket.each do |number|
      valid = false
      rules.each do |rule|
        if rule.is_valid?(number)
          valid = true
          break
        end
      end
      error_rate += number unless valid
    end
  end

  error_rate
end

def valid_tickets(rules, nearby_tickets)
  valid_tickets = []
  nearby_tickets.each do |ticket|
    valid_ticket = true
    ticket.each do |number|
      valid_number = false
      rules.each do |rule|
        if rule.is_valid?(number)
          valid_number = true
          break
        end
      end
      unless valid_number
        valid_ticket = false
        break
      end
    end
    valid_tickets << ticket if valid_ticket
  end

  valid_tickets
end

def valid_rules_per_column(rules, nearby_tickets)
  valid_rules_per_column = {}
  [*0..(rules.count - 1)].each do |col|
    valid_rules_per_column[col] = []
    rules.each do |rule|
      valid_for_entire_column = true
      [*0..(nearby_tickets.count - 1)].each do |row|
        number = nearby_tickets[row][col]
        unless rule.is_valid?(number)
          valid_for_entire_column = false
          break
        end
      end
      valid_rules_per_column[col] << rule.name if valid_for_entire_column
    end
  end
  valid_rules_per_column
end

rules = create_rule_objects("input-rules.txt")
nearby_tickets = get_tickets("input-nearby-tickets.txt")
puts "Puzzle 1: The error rate is #{error_rate(rules, nearby_tickets)}"

valid_tickets = valid_tickets(rules, nearby_tickets)

valid_rules_per_col_hash = valid_rules_per_column(rules, valid_tickets)
while valid_rules_per_col_hash.values.any?{|value| value.count > 1} do
  valid_rules_per_col_hash.each do |col1, rules1|
    if rules1.count == 1
      valid_rules_per_col_hash.each do |col2, rules2|
        next if col2 == col1
        valid_rules_per_col_hash[col2] -= [rules1.first]
      end
    end
  end
end

my_ticket = [83, 53, 73, 139, 127, 131, 97, 113, 61, 101, 107, 67, 79, 137, 89, 109, 103, 59, 149, 71]
cols_to_multiply = valid_rules_per_col_hash.select { |key, value| value.first.include?("departure") }.keys
result = my_ticket.values_at(*cols_to_multiply).inject(&:*)
puts "Puzzle 2: #{result}"