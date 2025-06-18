require 'pry'

DIRS = [
  [-1,0],
  [0,1],
  [1,0],
  [0,-1]
]

MAX_X = 71
MAX_Y = 71

def show_picture(picture)
  picture.each do |line|
    puts(line.join)
  end

  true
end

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

wall_hash = {}

(MAX_X + 2).times do |i|
  wall_hash[[0, i]] = nil
  wall_hash[[(MAX_Y+1), i]] = nil
end

map = []
map << Array.new((MAX_X + 2), '#')

MAX_Y.times do |i|
  wall_hash[[i, 0]] = nil
  wall_hash[[i, (MAX_X+1)]] = nil
  map << ['#'] + Array.new(MAX_X, '.') + ['#']
end

map << Array.new((MAX_X + 2), '#')

1024.times do
  column_index, line_index = file_data.shift.split(',').map { |n| n.to_i + 1 }

  wall_hash[[line_index, column_index]] = nil
  map[line_index][column_index] = '#'
end

start_position = [1,1]
finish_position = [MAX_Y, MAX_X]

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

puts best_points[finish_position]


