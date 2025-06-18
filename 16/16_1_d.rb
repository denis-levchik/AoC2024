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

def add_position(position, positions, best_points, points, wall_hash, dir_n)
  unless wall?(position, wall_hash)
    if !best_points.key?(position) || (best_points[position] > points)
      best_points[position] = points
      positions[[position[0], position[1], dir_n]] = points
    end
  end
end

file = File.open("test.txt")
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
best_points[start_position.dup] = 0

positions = {}
positions[start_position.push(1)] = 0

condition = false

while positions.any? do
  conditions, points = positions.shift
  line_index, column_index, dir_n = conditions

  positive_dir_n = (dir_n + 1) % 4
  negative_dir_n = (dir_n - 1) % 4

  p_step = step_position(line_index, column_index, positive_dir_n)
  step = step_position(line_index, column_index, dir_n)
  n_step = step_position(line_index, column_index, negative_dir_n)

  
  binding.pry if p_step == finish_position || step == finish_position || n_step == finish_position
  
  add_position(p_step, positions, best_points, (points + 1001), wall_hash, positive_dir_n)
  add_position(step, positions, best_points, (points + 1), wall_hash, dir_n)
  add_position(n_step, positions, best_points, (points + 1001), wall_hash, negative_dir_n)

  break if condition
end

puts best_points[finish_position]