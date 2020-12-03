class Password
  attr_reader :sha, :created_databases

  def initialize(idx1, idx2, letter, code)
    @idx1 = idx1
    @idx2 = idx2
    @letter = letter
    @code = code
  end

  def is_valid?
    code_array = @code.split('')
    result = false

    result = !result if code_array[@idx1-1] == @letter
    result = !result if code_array[@idx2-1] == @letter

    result
  end
end

valid_password_count = 0
file = File.readlines("input.txt")
file.each do |line|
  threshold, letter_symbol, code = line.split(' ')
  idx1, idx2 = threshold.split('-').map(&:to_i)
  letter = letter_symbol[0]

  password = Password.new(idx1, idx2, letter, code)
  valid_password_count +=1 if password.is_valid?
end

puts "There are #{valid_password_count} valid passwords"