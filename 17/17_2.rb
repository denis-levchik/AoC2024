require 'pry'

def program(a, program)
  b = 0
  c = 0
  i = 0
  pointer = 0
  count = program.count
  output = []
  i = 0

  while pointer < count do
    code = program[pointer]
    operand = program[pointer + 1]
  
    combo_operand = case operand
    when 0
      0
    when 1
      1
    when 2
      2
    when 3
      3
    when 4
      a
    when 5
      b
    when 6
      c
    end
  
    case code
    when 0
      a = a/(2**combo_operand)
      pointer += 2
    when 1
      b = b ^ operand
      pointer += 2
    when 2
      b = combo_operand % 8
      pointer += 2
    when 3
      if a != 0
        pointer = operand
      else
        pointer += 2
      end
    when 4
      b = b ^ c
      pointer += 2
    when 5
      # break if output != program[i]
      # i += 1
      output << (combo_operand % 8)
      pointer += 2
    when 6
      b = a/(2**combo_operand)
      pointer += 2
    when 7
      c = a/(2**combo_operand)
      pointer += 2
    end
  
    # break if condition
  end

  output
end

a = 0 # неизвестное, но вывод должен повторять программу

program = [2,4,1,1,7,5,4,4,1,4,0,3,5,5,3,0]

condition = false

loop do
  output = program(a, program)

  if output == [5,5,3,0]
    puts a
    puts output.join(',')
    puts '/////////////////'
  end
  break if a == 10000  

  a += 1
end

puts a