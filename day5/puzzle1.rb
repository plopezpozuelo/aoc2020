def calculate_seat_id(string)
  row = calculate_row(string[0..6])
  col = calculate_col(string[7..9])

  row*8 + col  
end


def calculate_row(row_info)
  row_range = [*0..127]
  row_info.chars.each do |char|
    front,back = row_range.each_slice((row_range.size/2)).to_a
    case char
    when 'F'
      row_range = front
    when 'B'
      row_range = back
    end
  end
  row_range.first
end

def calculate_col(col_info)
  col_range = [*0..7]
  col_info.chars.each do |char|
    left,right = col_range.each_slice((col_range.size/2)).to_a
    case char
    when 'L'
      col_range = left
    when 'R'
      col_range = right
    end
  end
  col_range.first
end

def puzzle1(seat_ids)
  highest_id = seat_ids.sort.last
  puts "The highest seat id is #{highest_id}"
end

def puzzle2(seat_ids)
  sorted_seat_ids = seat_ids.sort
  my_seat_id = 0

  sorted_seat_ids.each_with_index do |seat_id, index|
    if sorted_seat_ids[index + 1] - seat_id == 2
      my_seat_id = seat_id + 1
      break
    end
  end

  puts "My seat id is #{my_seat_id}"
end

file = File.readlines("input.txt", chomp: true)
seat_ids = Array.new()

file.each do |line|
  seat_ids << calculate_seat_id(line)
end

puzzle1(seat_ids)
puzzle2(seat_ids)



