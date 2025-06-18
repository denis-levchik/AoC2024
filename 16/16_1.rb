require 'pry'

DIRS = [
  [-1,0],
  [0,1],
  [1,0],
  [0,-1]
]

def step_position(line_index, column_index, dir_n)
  d_line, d_column = DIRS[dir_n]

  [line_index + d_line, column_index + d_column]
end

def wall?(step_position, wall_hash)
  wall_hash.key?(step_position)
end

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)
start_position = nil
finish_position = nil
wall_hash = {}

file_data.each_with_index do |line, line_index|
  line.chars.each_with_index do |value, column_index|
    if value == 'S'
      start_position = [line_index, column_index]
    elsif value == 'E'
      finish_position = [line_index, column_index]
    elsif value == '#'
      wall_hash[[line_index, column_index]] = nil
    end
  end
end

best_points = nil

current_positions = {}
current_positions[start_position.push(1)] = 0
# condition = false
loop do
  next_positions = {}

  while current_positions.any? do
    conditions, points = current_positions.shift
    line_index, column_index, dir_n = conditions

    step_position = step_position(line_index, column_index, dir_n)

    unless wall?(step_position, wall_hash)
      new_points = points + 1
      if next_positions.key?([step_position[0], step_position[1], dir_n])
        if step_position == finish_position
          best_points = new_points if new_points < best_points
        else
          next_positions[[step_position[0], step_position[1], dir_n]] = new_points if new_points < next_positions[[step_position[0], step_position[1], dir_n]]
        end
      else
        if step_position == finish_position
          best_points = new_points if !best_points.kind_of?(Integer) || new_points < best_points
        else
          if !best_points.kind_of?(Integer) || new_points < best_points
            next_positions[[step_position[0], step_position[1], dir_n]] = new_points
          end
        end
      end
    end

    new_points = points + 1000

    if !best_points.kind_of?(Integer) || new_points < best_points
      next_positions[[line_index, column_index, ((dir_n + 1) % 4)]] = new_points
      next_positions[[line_index, column_index, ((dir_n - 1) % 4)]] = new_points
    end
  end

  # break if condition
  if next_positions.any?
    current_positions = next_positions
  else
    break
  end
end

puts best_points