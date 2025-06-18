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

file = File.open("input.txt")
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

all_position_with_dir = []
current_position = start_position.dup
next_position = current_position
new_obstructions = []

while 
  next_position = next_position(current_position.dup, dir)

  if obstructions?(next_position, hash_obstructions)
    if dir_position == DIR_MAX_POSITION
      dir_position = 0
    else
      dir_position += 1
    end
    dir = DIRS[dir_position]
  else
    break unless (next_position[0] < max_line) && (next_position[0] > -1) && (next_position[1] < max_column) && (next_position[1] > -1)
    current_position = next_position
  end

  new_obstruction = next_position(current_position.dup, dir)
  new_obstructions << new_obstruction unless obstructions?(new_obstruction, hash_obstructions)
end

cycle = 0

new_obstructions.uniq.each do |new_obstruction|
  dir_position = 0
  dir = DIRS[dir_position]
  current_position = start_position.dup

  hash_obstructions[new_obstruction] = nil

  all_position_hash = {}

  while
    next_position = next_position(current_position.dup, dir)
    break unless (next_position[0] < max_line) && (next_position[0] > -1) && (next_position[1] < max_column) && (next_position[1] > -1)
  
    if obstructions?(next_position, hash_obstructions)
      if dir_position == DIR_MAX_POSITION
        dir_position = 0
      else
        dir_position += 1
      end
      dir = DIRS[dir_position]
    else
      current_position = next_position
    end
  
    key = [current_position, dir_position].flatten

    if all_position_hash.key?(key)
      cycle += 1
      break
    else
      all_position_hash[key] = nil
    end
  end

  hash_obstructions.delete(new_obstruction)
end

puts cycle