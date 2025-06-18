require 'pry'

CYCLE = 100
MAX_X = 101
MAX_Y = 103

file = File.open("input_2.txt")
file_data = file.readlines.map(&:chomp)

middle_x = MAX_X/2
middle_y = MAX_Y/2

first = 0
second = 0
third = 0
fourth = 0

file_data.each do |line|
  p_x, p_y, v_x, v_y = line.scan(/p\=?(\-?\d*),?(\-?\d*) v=?(\-?\d*),?(\-?\d*)/).first.map(&:to_i)

  new_x = (p_x + v_x * CYCLE) % MAX_X
  new_y = (p_y + v_y * CYCLE) % MAX_Y

  unless new_x == middle_x || new_y == middle_y
    if new_x < middle_x
      if new_y < middle_y
        first += 1
      else
        third += 1
      end
    else
      if new_y < middle_y
        second += 1
      else
        fourth += 1
      end
    end
  end
end

puts(first * second * third * fourth)