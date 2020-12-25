def make_move(cups, current_cup)
  current_index = cups.index(current_cup)
  picked_up_cups = []
  3.times do
    index = current_index + 1
    index = 0 if index >= cups.length
    picked_up_cups << cups.delete_at(index)
  end

  destination_cup = current_cup - 1
  while !cups.include?(destination_cup)
    destination_cup -= 1
    destination_cup = cups.max if destination_cup < cups.min
  end

  destination_index = cups.index(destination_cup)
  cups.insert(destination_index + 1, picked_up_cups).flatten!

  current_index = cups.index(current_cup)
  next_current_cup = cups[(current_index + 1) % cups.length]
  return cups, next_current_cup
end

test_input = [3, 8, 9, 1, 2, 5, 4, 6, 7]
input = [1, 8, 6, 5, 2, 4, 9, 7, 3]

cups = input
current_cup = cups.first
100.times do
  cups, current_cup = make_move(cups, current_cup)
end

puts "Result 1: #{cups.inspect}"
