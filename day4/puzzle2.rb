class Passport
  def initialize(args)
    @byr = args[:byr] if args[:byr]
    @iyr = args[:iyr] if args[:iyr]
    @eyr = args[:eyr] if args[:eyr]
    @hgt = args[:hgt] if args[:hgt]
    @hcl = args[:hcl] if args[:hcl]
    @ecl = args[:ecl] if args[:ecl]
    @pid = args[:pid] if args[:pid]
    @cid = args[:cid] if args[:cid]
  end

  def is_valid?
    return false unless byr_valid?
    return false unless iyr_valid?
    return false unless eyr_valid?
    return false unless hgt_valid?
    return false unless hcl_valid?
    return false unless ecl_valid?
    return false unless pid_valid?

    true
  end

  def byr_valid?
    return false if @byr.nil?
    return false unless is_numeric?(@byr)
    return false if @byr.to_i < 1920
    return false if @byr.to_i > 2002

    true
  end

  def iyr_valid?
    return false if @iyr.nil?
    return false unless is_numeric?(@iyr)
    return false if @iyr.to_i < 2010
    return false if @iyr.to_i > 2020

    true
  end

  def eyr_valid?
    return false if @eyr.nil?
    return false unless is_numeric?(@eyr)
    return false if @eyr.to_i < 2020
    return false if @eyr.to_i > 2030

    true
  end

  def hgt_valid?
    return false if @hgt.nil?

    value = @hgt.to_i
    unit = @hgt.gsub(value.to_s, '')
    return false unless ['cm', 'in'].include?(unit)

    case unit
    when 'in'
      return false if @hgt.to_i < 59
      return false if @hgt.to_i > 76
    when 'cm'
      return false if @hgt.to_i < 150
      return false if @hgt.to_i > 193
    end

    true
  end

  def hcl_valid?
    return false if @hcl.nil?
    return false unless @hcl[0] == '#'
    return false unless is_hexadecimal?(@hcl[1..])

    true
  end

  def ecl_valid?
    return false if @ecl.nil?

    valid_ecls = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
    return false unless valid_ecls.include?(@ecl)

    true
  end

  def pid_valid?
    return false if @pid.nil?
    return false unless is_numeric?(@pid)
    return false unless @pid.length == 9

    true
  end

  private def is_numeric?(string)
    string.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
   end

  private def is_hexadecimal?(string)
    return false if string.length != 6

    string.chars.each do |digit|
      return false unless digit.match(/[0-9A-Fa-f]/)
    end

    true
  end
end

def passports_from_file(file)
  passports = Array.new()
  passport_string = String.new()

  file.each_with_index do |line, index|
    next if line.empty?

    if file[index+1].nil? || file[index+1].empty?
      passport_string += " " + line
      passports << passport_from_string(passport_string)
      passport_string = ""
    else
      passport_string += " " + line
    end
  end

  passports
end

def passport_from_string(string)
  key_value_array = string.split(' ').map{ |s| s.split(':') }
  args = key_value_array.to_h.map{ |k,v| [k.to_sym, v]  }.to_h
  Passport.new(args)
end

file = File.readlines("input.txt", chomp: true)
passports = passports_from_file(file)
valid_count = passports.select(&:is_valid?).count

puts "There are #{valid_count} valid passports"
