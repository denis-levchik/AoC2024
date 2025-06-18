require 'pry'

def calculate_register(first, second, operand)
  case operand
  when 'XOR'
    first ^ second
  when 'OR'
    first | second
  when 'AND'
    first & second
  end
end

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

registers = {}

line = file_data.shift
result = 0

while !line.empty? do
  register, value = line.split(': ')
  registers[register] = value.to_i

  line = file_data.shift
end

result = 0

while file_data.any? do
  i = 0
  while i < file_data.count
    line = file_data[i]

    first_r, operand, second_r, final_r = line.scan(/(...) ?(\w*) (...) -> (...)/).first

    if registers[first_r].kind_of?(Integer) && registers[second_r].kind_of?(Integer)
      file_data.delete_at(i)

      register_value = calculate_register(registers[first_r], registers[second_r], operand)

      registers[final_r] = register_value

      if final_r.start_with?('z')
        result += 2 ** final_r.scan(/z(\d*)/).first.first.to_i if register_value == 1
      end
    else
      i += 1
    end
  end
end

puts result
