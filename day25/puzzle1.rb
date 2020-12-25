MOD = 20201227

def find_encryption_key(card_pk, door_pk)
  card_loop_size = find_loop_size(card_pk)
  transform_subject_number(card_loop_size, door_pk)
end

def transform_subject_number(loop_size, subject_number)
  value = 1
  loop_size.times do
    value = (value * subject_number) % MOD
  end
  value
end

def find_loop_size(publick_key, subject_number = 7)
  value = 1
  loop_size = 0
  while value != publick_key do
    value = (value * subject_number) % MOD
    loop_size += 1
  end
  loop_size
end

card_pk = 9717666
door_pk = 20089533
puts "Puzzle 1: #{find_encryption_key(card_pk, door_pk)}"
