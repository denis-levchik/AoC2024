require 'pry'

OPERATIONS = ['+', '*', '||']
file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

sum = 0

file_data.each do |line|
  finish, values = line.split(':')
  finish = finish.to_i
  values = values.split.map(&:to_i)
  
  solutions = [values.shift]

  while values.any?
    next_value = values.shift

    next_solutions = []

    while solutions.any?
      number = solutions.shift

      OPERATIONS.each do |operation|
        if operation == '*'
          next_solutions << next_value * number
        elsif operation == '+'
          next_solutions << next_value + number
        else
          next_solutions << (number.to_s + next_value.to_s).to_i
        end
      end
    end

    solutions = next_solutions
  end

  sum += finish if solutions.include?(finish)
end

puts sum