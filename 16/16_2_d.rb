require 'pry'

DIRS = [
  [-1,0],
  [0,1],
  [1,0],
  [0,-1]
]

def show_picture(best_points, wall_hash, max_column, max_line)
  start_picture = []

  max_line.times do
    start_picture << Array.new(max_column, '.')
  end


  best_points.each do |position, points|
    start_picture[position[0]][position[1]] = points.to_s.rjust(6)
  end

  wall_hash.each do |position, _value|
    start_picture[position[0]][position[1]] = '     #'
  end

  start_picture.each do |line|
    puts(line.join)
  end

  true
end

def step_position(line_index, column_index, dir_n)
  d_line, d_column = DIRS[dir_n]

  [line_index + d_line, column_index + d_column]
end

def previous_position(line_index, column_index, dir_n)
  d_line, d_column = DIRS[dir_n]

  [line_index + (d_line * -1), column_index + (d_column * -1)]
end

def wall?(step_position, wall_hash)
  wall_hash.key?(step_position)
end

def add_tiles(position, gen1, tiles, best_points, points, dir_n)
  key = [position[0], position[1], dir_n]

  
  binding.pry if position == [13,13]
  

  if best_points[key] == points
    gen1[key] = points
    tiles[position] = nil
  end
end

def add_position(position, positions, best_points, points, wall_hash, dir_n)
  unless wall?(position, wall_hash)
    key = [position[0], position[1], dir_n]
    if !best_points.key?(key) || (best_points[key] >= points)
      best_points[key] = points
      positions[key] = points
    end
  end
end

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)
start_position = nil
finish_position = nil
wall_hash = {}

max_line = file_data.count
max_column = file_data.first.size

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
best_points[start_position.push(1)] = 0

positions = {}
positions[start_position] = 0

condition = false

while positions.any? do
  conditions, points = positions.shift
  line_index, column_index, dir_n = conditions

  positive_dir_n = (dir_n + 1) % 4
  negative_dir_n = (dir_n - 1) % 4

  p_step = step_position(line_index, column_index, positive_dir_n)
  step = step_position(line_index, column_index, dir_n)
  n_step = step_position(line_index, column_index, negative_dir_n)

  
  # binding.pry if p_step == [7,6] || step == [7,6] || n_step == [7,6]
  
  add_position(p_step, positions, best_points, (points + 1001), wall_hash, positive_dir_n)
  add_position(step, positions, best_points, (points + 1), wall_hash, dir_n)
  add_position(n_step, positions, best_points, (points + 1001), wall_hash, negative_dir_n)

  break if condition
end

gen0 = {}
tiles = {}
tiles[finish_position] = nil

if best_points[[finish_position[0], finish_position[1], 0]] == best_points[[finish_position[0], finish_position[1], 1]]
  gen0[[finish_position[0], finish_position[1], 0]] = best_points[[finish_position[0], finish_position[1], 0]]
  gen0[[finish_position[0], finish_position[1], 1]] = best_points[[finish_position[0], finish_position[1], 0]]
elsif best_points[[finish_position[0], finish_position[1], 0]] < best_points[[finish_position[0], finish_position[1], 1]]
  gen0[[finish_position[0], finish_position[1], 0]] = best_points[[finish_position[0], finish_position[1], 0]]
else
  gen0[[finish_position[0], finish_position[1], 1]] = best_points[[finish_position[0], finish_position[1], 1]]
end

condition = false

loop do
  gen1 = {}

  while gen0.any? do
    key, points = gen0.shift
    line_index, column_index, dir_n = key

    positive_dir_n = (dir_n + 1) % 4
    negative_dir_n = (dir_n - 1) % 4

    # p_pos = previous_position(line_index, column_index, positive_dir_n)
    pos = previous_position(line_index, column_index, dir_n)
    # n_pos = previous_position(line_index, column_index, negative_dir_n)

    # binding.pry if pos == [13,13]

    add_tiles(pos, gen1, tiles, best_points, (points - 1001), positive_dir_n) unless wall?(pos, wall_hash)
    add_tiles(pos, gen1, tiles, best_points, (points - 1), dir_n) unless wall?(pos, wall_hash)
    add_tiles(pos, gen1, tiles, best_points, (points - 1001), negative_dir_n) unless wall?(pos, wall_hash)

    # if !wall?(pos, wall_hash) && points > 0
    #   add_tiles(pos, gen1, tiles, best_points, (points - 1), dir_n)

    #   gen1[[pos[0], pos[1], positive_dir_n]] = points - 1000 
    #   gen1[[pos[0], pos[1], negative_dir_n]] = points - 1000
    # end
  end

  if gen1.any? || condition
    gen0 = gen1
  else
    break
  end
end

puts tiles.count
