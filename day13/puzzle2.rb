def buses_with_index(filename)
  file = File.readlines(filename, chomp: true).map(&:strip)

  buses_with_index = Hash.new(0)
  file[1].split(',').each_with_index do |bus, idx|
    next if bus == 'x'
    buses_with_index[bus.to_i] = idx
  end

  buses_with_index
end

def earliest_timestamp_slow(buses_with_index)
  largest_bus = buses_with_index.keys.max
  timestamp_to_check = largest_bus - buses_with_index[largest_bus]

  loop do
    puts timestamp_to_check
    non_eligible_buses = buses_with_index.reject { |bus, index| (timestamp_to_check + index) % bus == 0 }

    return timestamp_to_check if non_eligible_buses.empty?
    timestamp_to_check += largest_bus
  end
end

def extended_gcd(a, b)
  last_remainder, remainder = a.abs, b.abs
  x, last_x, y, last_y = 0, 1, 1, 0
  while remainder != 0
    last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
    x, last_x = last_x - quotient*x, x
    y, last_y = last_y - quotient*y, y
  end
  return last_remainder, last_x * (a < 0 ? -1 : 1)
end
 
def invmod(e, et)
  g, x = extended_gcd(e, et)
  if g != 1
    raise 'Multiplicative inverse modulo does not exist!'
  end
  x % et
end
 
def chinese_remainder(mods, remainders)
  max = mods.inject( :* )
  series = remainders.zip(mods).map{ |r,m| (r * max * invmod(max/m, m) / m) }
  series.inject( :+ ) % max 
end

def earliest_timestamp_fast(buses_with_index)
  mods = []
  remainders = []

  buses_with_index.each do |bus, idx|
    mods << bus
    remainders << bus - idx
  end

  chinese_remainder(mods, remainders)
end

buses_with_index = buses_with_index('input.txt')
earliest_timestamp = earliest_timestamp_fast(buses_with_index)
puts "Result: #{earliest_timestamp}"