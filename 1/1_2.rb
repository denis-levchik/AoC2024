file = File.open("input.txt")
file_data = file.readlines

array_first = []
array_two = []

file_data.each do |line|
  numbers = line.chomp.split('   ').map(&:to_i)
  array_first << numbers[0]
  array_two << numbers[1]
end

sum = 0

array_first.length.times do |i|
  count = array_two.count(array_first[i])
  sum += array_first[i] * count
end

puts sum