require 'pry'

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)
stones_array = file_data.first.split.map(&:to_i)

count = 0

count_zero = []

stones_array.each do |value|
  stones = [value]
  next_stones = []

  35.times do |i|
    while stones.any? do
      stone = stones.shift

      if stone == 0
        next_stones.push(1)
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

        next_stones.push(first)
        next_stones.push(second)
      else
        next_stones.push(stone * 2024)
      end
    end

    stones = next_stones.dup

    next_stones = []
  end

  count += stones.count
end

puts "Количество камней на 35 шаге: #{count}"