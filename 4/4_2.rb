require 'pry'

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

a_array = []
input = []

file_data.each_with_index do |line, line_index|
  line = line.chars
  input << line
  line.each_with_index do |value, column_index|
    a_array << [line_index, column_index] if value == 'A'
  end
end

line_count = input.count
column_count = input[0].count

count = 0

a_array.each_with_index do |a,i|
  puts i
  x = a[0]
  y = a[1]
  next if (x == 0) || (y == 0) || (x == (line_count - 1)) || (y == (column_count - 1))
  north_west_letter = input[x-1][y+1]
  north_east_letter = input[x+1][y+1]
  south_west_letter = input[x-1][y-1]
  south_east_letter = input[x+1][y-1]

  condition_1 = false
  condition_2 = false

  if north_west_letter == 'M' && south_east_letter == 'S'
    condition_1 = true
  elsif north_west_letter == 'S' && south_east_letter == 'M'
    condition_1 = true
  end

  if north_east_letter == 'M' && south_west_letter == 'S'
    condition_2 = true
  elsif north_east_letter == 'S' && south_west_letter == 'M'
    condition_2 = true
  end

  count += 1 if condition_1 && condition_2
end

puts(count)