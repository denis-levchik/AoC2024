require 'pry'

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

sum = 0

while file_data.any?
  conditions = file_data.shift(4)

  a = conditions[0].scan(/X\+?(\d*), Y\+?(\d*)/).first.map(&:to_i)
  b = conditions[1].scan(/X\+?(\d*), Y\+?(\d*)/).first.map(&:to_i)
  result = conditions[2].scan(/X\=?(\d*), Y\=?(\d*)/).first.map(&:to_i)

  a << 3
  b << 1

  additions = {
    a: a,
    b: b
  }

  start_positions = { [0,0,0,0] => 0 }

  best_prize = nil

  loop do
    next_positions = {}

    start_positions.each do |x_y_a_b, prize|
      x,y,a,b = x_y_a_b
      additions.each do |key, value|
        add_x, add_y, add_prize = value
        new_a = key == :a ? a + 1 : a
        new_b = key == :b ? b + 1 : b

        new_x = x + add_x
        new_y = y + add_y
        new_x_y = [new_x, new_y]
        new_prize = prize + add_prize
        
        if new_x_y == result
          best_prize = new_prize if !best_prize.kind_of?(Integer) || (new_prize < best_prize)
        elsif (new_x < result[0]) && (new_y < result[1]) && new_a <= 100 && new_b <= 100
          new_x_y_a_b = [new_x, new_y, new_a, new_b]
          if next_positions.key?(new_x_y_a_b)
            next_positions[new_x_y_a_b] = new_prize if next_positions[new_x_y_a_b] > new_prize
          else
            next_positions[new_x_y_a_b] = new_prize
          end
        end
      end
    end

    if next_positions.any?
      start_positions = next_positions
    else
      break
    end
  end
  sum += best_prize if best_prize.kind_of?(Integer)
end

puts sum