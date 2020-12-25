require "progress_bar"

def make_move(cups, current_cup)
  # Find 3 cups and remove from linked list
  cup1 = cups[current_cup]
  cup2 = cups[cup1]
  cup3 = cups[cup2]
  picked_up_cups = [cup1, cup2, cup3]
  cups[current_cup] = cups[cup3]

  # Find destination cup
  destination_cup = current_cup - 1
  destination_cup = cups.length if destination_cup == 0
  while picked_up_cups.include?(destination_cup)
    destination_cup = (destination_cup - 1) % cups.length
    destination_cup = cups.length if destination_cup == 0
  end

  # Insert 3 cups after destination cup
  destination_next_cup = cups[destination_cup]
  cups[destination_cup] = cup1
  cups[cup3] = destination_next_cup

  return cups, cups[current_cup]
end

def generate_cups_hash(input)
  cups_hash = {}
  input.each_with_index do |int, idx|
    next_index = (idx == input.length - 1) ? 0 : idx + 1
    cups_hash[int] = input[next_index]
  end

  cups_hash
end

input = [1, 8, 6, 5, 2, 4, 9, 7, 3] + (10..1_000_000).to_a
bar = ProgressBar.new(10_000_000)
cups = generate_cups_hash(input)
current_cup = input.first

10_000_000.times do
  cups, current_cup = make_move(cups, current_cup)
  bar.increment!
end

result = cups[1] * cups[cups[1]]
puts "Result 1: #{result}"
