require 'pry'

DIR_MAX_POSITION = 3

DIRS = [
  [-1,0],
  [0,1],
  [1,0],
  [0,-1]
]

def next_position(position, dir)
  position[0] = position[0] + dir[0]
  position[1] = position[1] + dir[1]

  position
end

def obstructions?(position, hash_obstructions)
  hash_obstructions.key?(position)
end

file = File.open("input_2.txt")
file_data = file.readlines.map(&:chomp)

hash_obstructions = {}
start_position = []

dir_position = 0
dir = DIRS[dir_position]

max_line = file_data.count
max_column = file_data[0].length

file_data.each_with_index do |line, line_index|
  line.chars.each_with_index do |value, column_index|
    if value == '^'
      start_position = [line_index, column_index]
    elsif value == '#'
      hash_obstructions[[line_index, column_index]] = nil
    end
  end
end

all_position = {start_position: nil} 
next_position = start_position

while 
  next_position = next_position(start_position.dup, dir)

  if obstructions?(next_position, hash_obstructions)
    if dir_position == DIR_MAX_POSITION
      dir_position = 0
    else
      dir_position += 1
    end
    dir = DIRS[dir_position]
  else
    break unless (next_position[0] < max_line) && (next_position[0] > -1) && (next_position[1] < max_column) && (next_position[1] > -1)
    start_position = next_position

    unless all_position.key?(next_position)
      all_position[next_position] = nil
    end
  end
end

puts (all_position.keys.count)