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
    return false if @byr.nil?
    return false if @iyr.nil?
    return false if @eyr.nil?
    return false if @hgt.nil?
    return false if @hcl.nil?
    return false if @ecl.nil?
    return false if @pid.nil?

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
