require 'pry'

def sort_numbers(numbers, hash_rules)
  sort_numbers = []

  numbers.each do |number|
    if sort_numbers.empty?
      sort_numbers << number
    else
      index = nil

      sort_numbers.each_with_index do |s_number, i|
        if hash_rules[s_number].kind_of?(Array) && hash_rules[s_number].include?(number)
          index = i
          break
        end
      end

      if index.kind_of?(Integer)
        sort_numbers.insert(index, number)
      else
        sort_numbers << number
      end
    end
  end

  sort_numbers
end

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
wrong_line = []

file_data.each_with_index do |line_numbers, i|
  numbers = line_numbers.split(',').map(&:to_i)
  rev_numbers = numbers.reverse

  condition = true

  number = rev_numbers.shift

  while rev_numbers.any? do
    rules = hash_rules[number]

    if rules.kind_of?(Array) && (rules & rev_numbers).any?
      condition = false
      break
    end

    number = rev_numbers.shift
  end
  
  unless condition
    s_numbers = sort_numbers(numbers, hash_rules)

    sum += s_numbers[s_numbers.length/2]
  end
end

puts sum
