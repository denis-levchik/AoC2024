require 'pry'

def move_stone(count, next_stone, stones)
  if stones.key?(next_stone)
    stones[next_stone] += count
  else
    stones[next_stone] = count
  end
end

def move_stones(count, next_stones, stones)
  next_stones.each do |next_stone|
    move_stone(count, next_stone, stones)
  end
end

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)
stones = {}

file_data.first.split do |value|
  stones[value.to_i] = 1
end

75.times do |i|
  current_stones = stones.keys
  next_stones = {}

  while current_stones.any? do
    stone = current_stones.shift
    count = stones[stone]

    if stone == 0
      move_stone(count, 1, next_stones)
    elsif (digits = stone.digits) && (digits.count % 2 == 0)
      middle = digits.count / 2

      first = 0
      second = 0

      digits.shift(middle).each_with_index do |n, i|
        first += n * (10 ** i)
      end

      digits.each_with_index do |n, i|
        second += n * (10 ** i)
      end

      move_stones(count, [first, second], next_stones)
    else
      move_stone(count, (stone * 2024), next_stones)
    end
  end

  stones = next_stones.dup
end

puts "Количество камней: #{stones.values.sum}"