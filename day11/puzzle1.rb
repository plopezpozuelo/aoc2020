def count_adjacent_occupied_seats(seat_map, row, col)
  count = 0
  directions = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
  directions.each do |direction|
    target_row = row + direction[0]
    target_col = col + direction[1]
    next if target_row < 0 || target_row >= seat_map.count || target_col < 0 || target_col >= seat_map.first.count

    count += 1 if seat_map[target_row][target_col] == "#"
  end

  count
end

def solution(seat_map)
  loop do
    new_seat_map = seat_map.map(&:dup)
    seat_map.each_with_index do |line, row|
      line.each_with_index do |seat, col|
        next if seat == "."

        count = count_adjacent_occupied_seats(seat_map, row, col)
        if seat == "L" && count == 0
          new_seat_map[row][col] = "#"
        elsif seat == "#" && count >= 4
          new_seat_map[row][col] = "L"
        end
      end
    end

    if new_seat_map == seat_map
      occupied_seats = new_seat_map.flatten.count("#")
      puts "There are #{occupied_seats} occupied seats"
      break
    end

    seat_map = new_seat_map
  end
end

seat_map = File.readlines("input.txt", chomp: true).map(&:strip).map(&:chars)
solution(seat_map)
