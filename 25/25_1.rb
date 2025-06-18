require 'pry'

MAX_VALUE = 7

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

keys = []
locks = []

while file_data.any?
  array = file_data.shift(7)
  array.map! { |line| line.chars }
  file_data.shift
  
  if array[0][0] == '#'
    locks << array.transpose.map { |line| line.count('#') }
  else
    keys << array.transpose.map { |line| line.count('#') }
  end
end

count = 0

locks.each do |lock|
  keys.each do |key|
    condition = true
    
    5.times do |i|
      sum = lock[i] + key[i]

      if sum > MAX_VALUE
        condition = false
        break
      end
    end

    count += 1 if condition
  end
end

puts count
