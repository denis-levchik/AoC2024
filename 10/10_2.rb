require 'pry'

DIRS = [
  [-1,0],
  [0,1],
  [1,0],
  [0,-1]
]
file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

coordinates_zero = []

file_data.map!.with_index do |line, line_index|
  line = line.chars.map(&:to_i)

  line.each_with_index do |value, column_index|
    if value == 0
      coordinates_zero << [line_index + 1, column_index + 1, 0]
    end
  end

  line.unshift(-1)
  line.push(-1)
end

file_data.unshift(Array.new(file_data[0].length, -1))
file_data.push(Array.new(file_data[0].length, -1))
count = 0

while coordinates_zero.any? do
  coordinates = {} 
  coordinates = [coordinates_zero.shift]

  while coordinates.any? do
    line, column, value = coordinates.shift

    DIRS.each do |d_line, d_column|
      new_line = line + d_line
      new_column = column + d_column
      new_value = file_data[new_line][new_column]
      
      if new_value == (value + 1)
        if new_value == 9
          count += 1
        else
          coordinates << [new_line, new_column, new_value]
        end
      end 
    end
  end
end

puts count
