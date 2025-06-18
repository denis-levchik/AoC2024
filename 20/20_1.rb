require 'pry'

DIRS = [
  [-1,0],
  [0,1],
  [1,0],
  [0,-1]
]

def wall?(position, wall_hash)
  wall_hash.key?(position)
end

def add_position(position, positions, best_points, points, wall_hash)
  unless wall?(position, wall_hash)
    unless best_points.key?(position)
      best_points[position] = points + 1
      positions[position] = points + 1
    end
  end
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

best_points = {}
best_points[start_position] = 0

positions = {}
positions[start_position] = 0

condition = false

while positions.any? do
  conditions, points = positions.shift
  line_index, column_index = conditions

  DIRS.each do |d_line, d_column|
    next_positions = [line_index + d_line, column_index + d_column]

    add_position(next_positions, positions, best_points, points, wall_hash)
  end

  break if condition || best_points.key?(finish_position)
end

all_pairs = best_points.to_a.combination(2)
all_cheats = {}
count = 0

all_pairs.each do |a, b|
  a_pos, a_points = a
  b_pos, b_points = b

  if (b_points - a_points) > 100
    if a_pos[0] == b_pos[0]
      count += 1 if (a_pos[1] - b_pos[1]).abs == 2
    elsif a_pos[1] == b_pos[1]
      count += 1 if (a_pos[0] - b_pos[0]).abs == 2
    end
  end
end

puts count
