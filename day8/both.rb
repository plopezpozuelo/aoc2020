class Instruction

  attr_accessor :operation, :int, :visited

  def initialize(operation, int, visited=false)
    @operation = operation
    @int = int
    @visited = visited
  end

end

def program_from_file(filename)
  file = File.readlines(filename, chomp: true)
  program = Array.new()

  file.each do |line|
    operation, int_string = line.split(" ")
    program << Instruction.new(operation, int_string.to_i)
  end

  program
end

def reset_program(program)
  program.each do |instruction|
    instruction.visited = false
  end
end

def execute_program(program)
  acc = 0
  idx = 0

  while idx < program.length && !program[idx].visited do
    instruction = program[idx]
    case instruction.operation
    when "nop"
      idx += 1
    when "acc"
      acc += instruction.int
      idx += 1
    when "jmp"
      idx += instruction.int
    end
    instruction.visited = true
  end
  reset_program(program)

  return acc, idx
end

def puzzle1(program)
  acc = execute_program(program).first
  puts "Puzzle 1: The value of the accumulator is #{acc}"
end

def puzzle2(program)
  acc = 0
  count = 0
  program.each do |instruction|
    next if instruction.operation == "acc"

    instruction.operation = instruction.operation == "jmp" ? "nop" : "jmp"

    acc, idx = execute_program(program)
    break if idx > program.length

    instruction.operation = instruction.operation == "jmp" ? "nop" : "jmp"
  end

  puts "Puzzle 2: The value of the accumulator is #{acc}"
end

program = program_from_file("input.txt")
puzzle1(program)
puzzle2(program)