require 'pry'

def calculate_antinode(c_1, c_2)
  d_line = (c_1[0] - c_2[0])
  d_column = (c_1[1] - c_2[1])

  [c_1[0] + d_line, c_1[1] + d_column]
end

def add_antinodes(antinode, previous_antinode, all_antinodes, max_line, max_column)
  while (antinode[0] < max_line) && (antinode[0] > -1) && (antinode[1] < max_column) && (antinode[1] > -1)
    all_antinodes[antinode] = nil
    
    intermediate = calculate_antinode(antinode, previous_antinode)
    previous_antinode = antinode
    antinode = intermediate
  end
end

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

max_line = file_data.count
max_column = file_data[0].length

antennas = {}

file_data.each_with_index do |line, line_index|
  line.chars.each_with_index do |value, column_index|
    if value != '.'
      if antennas.key?(value)
        antennas[value] << [line_index, column_index]
      else
        antennas[value] = [[line_index, column_index]]
      end
    end
  end
end

all_antinodes = {}

antennas.each do |key, coordinates|
  if coordinates.count > 1
    coordinates.each do |c|
      all_antinodes[c] = nil
    end

    combinations = coordinates.combination(2)

    combinations.each do |c_1, c_2|
      first_antinode = calculate_antinode(c_1, c_2)
      add_antinodes(first_antinode, c_1, all_antinodes, max_line, max_column)
  
      second_antinode = calculate_antinode(c_2, c_1)
      add_antinodes(second_antinode, c_2, all_antinodes, max_line, max_column)
    end
  end
end

puts all_antinodes.count

