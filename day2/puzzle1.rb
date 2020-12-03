class Password
  attr_reader :sha, :created_databases

  def initialize(min, max, letter, code)
    @min = min
    @max = max
    @letter = letter
    @code = code
  end

  def is_valid?
    letter_count = @code.count(@letter)
    return false if letter_count < @min
    return false if letter_count > @max

    true
  end
end

valid_password_count = 0
file = File.readlines("input.txt")
file.each do |line|
  threshold, letter_symbol, code = line.split(' ')
  min, max = threshold.split('-').map(&:to_i)
  letter = letter_symbol[0]

  password = Password.new(min, max, letter, code)
  valid_password_count +=1 if password.is_valid?
end

puts "There are #{valid_password_count} valid passwords"