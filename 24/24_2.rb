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

def calculate_number(file_data, registers)
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
  result
end

def first_different_grade(number_1, number_2)
  i = 1

  while i < 46 do
    grade = sum_2[-i]
    custom_grade = custom_sum_2[-i]
  
    if grade != custom_grade
      return i
    end
  
    i += 1
  end

  -1
end

x = 0
y = 0

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

registers = {}

line = file_data.shift
result = 0

while !line.empty? do
  register, value = line.split(': ')
  registers[register] = value.to_i

  line = file_data.shift

  if register.start_with?('x')
    x += 2 ** register.scan(/x(\d*)/).first.first.to_i if value.to_i == 1
  elsif register.start_with?('y')
    y += 2 ** register.scan(/y(\d*)/).first.first.to_i if value.to_i == 1
  end
end

sum = x + y

sum_2 = sum.to_s(2)

custom_sum_2 = calculate_number(file_data.dup, registers).to_s(2)


binding.pry

register_info = {}

# file_data.each do |line|
#   expression, value = line.split(' -> ')
#   register_info[expression] = value
# end

i = 1

while i < 46 do
  grade = sum_2[-i]
  custom_grade = custom_sum_2[-i]

  if grade != custom_grade
    puts i
  end

  i += 1
end


