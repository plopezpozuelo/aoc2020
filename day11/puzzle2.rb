def count_visible_occupied_seats(seat_map, row, col)
  count = 0

  directions = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
  directions.each do |direction|
    count += 1 if closest_visible_seat_occupied_in_direction?(seat_map, row, col, direction[0], direction[1])
  end

  count
end

def closest_visible_seat_occupied_in_direction?(seat_map, row, col, row_dir, col_dir)
  loop do
    row += row_dir
    col += col_dir
    return false if row < 0 || row >= seat_map.count || col < 0 || col >= seat_map.first.count

    seat = seat_map[row][col]
    return true if seat == "#"
    return false if seat == "L"
  end
end

def solution(seat_map)
  loop do
    new_seat_map = seat_map.map(&:dup)
    seat_map.each_with_index do |line, row|
      line.each_with_index do |seat, col|
        next if seat == "."

        count = count_visible_occupied_seats(seat_map, row, col)
        if seat == "L" && count == 0
          new_seat_map[row][col] = "#"
        elsif seat == "#" && count >= 5
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
