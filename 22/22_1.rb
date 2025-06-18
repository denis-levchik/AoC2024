require 'pry'

def calculate_result(number)
  first_step = ((number << 6) ^ number) & 16_777_215
  second_step = ((first_step >> 5) ^ first_step) & 16_777_215
  third_step = ((second_step << 11) ^ second_step) & 16_777_215
end

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

sum = 0

file_data.each do |line|
  number = line.to_i

  result = calculate_result(number)

  1999.times do
    result = calculate_result(result)
  end

  sum += result
end

puts sum