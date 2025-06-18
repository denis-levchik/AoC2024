require 'pry'

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

line = file_data.shift
hash_rules = {}

while line != '' do
  array = line.split('|').map(&:to_i)

  if hash_rules.key?(array[0])
    hash_rules[array[0]] << array[1]
  else
    hash_rules[array[0]] = [array[1]]
  end

  line = file_data.shift
end

sum = 0

file_data.each_with_index do |line_numbers, i|
  numbers = line_numbers.split(',').map(&:to_i).reverse
  middle_number = numbers[((numbers.length/2))]
  
  condition = true

  number = numbers.shift

  while numbers.any? do
    rules = hash_rules[number]

    if rules.kind_of?(Array) && (rules & numbers).any?
      condition = false
      break
    end

    number = numbers.shift
  end

  sum += middle_number if condition
end

puts sum
