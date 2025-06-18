require 'pry'

DIRS = {
  '^' => [-1, 0],
  '>' => [0, 1],
  'v' => [1, 0],
  '<' => [0, -1]
}

def calculate_position(old_position, dir_c)
  [(old_position[0] + dir_c[0]), (old_position[1] + dir_c[1])]
end

def box?(position, box_hash)
  box_hash.key?(position)
end

def wall?(position, wall_hash)
  wall_hash.key?(position)
end

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

line = file_data.shift
line_index = 0

robot_position = nil
box_hash = {}
wall_hash = {}

while !line.empty? do
  line.chars.each_with_index do |value, column_index|
    if value == '@'
      robot_position = [line_index, column_index]
    elsif value == 'O'
      box_hash[[line_index, column_index]] = nil
    elsif value == '#'
      wall_hash[[line_index, column_index]] = nil
    end
  end
  line_index += 1
  line = file_data.shift
end

file_data.each do |dirs|
  dirs.chars.each do |dir|
    dir_c = DIRS[dir]

    new_robot_position = calculate_position(robot_position, dir_c)

    if box?(new_robot_position, box_hash)
      box_hash.delete(new_robot_position)
      boxs = [new_robot_position]
      
      next_position = calculate_position(new_robot_position, dir_c)

      while box?(next_position, box_hash) do
        box_hash.delete(next_position)
        boxs << next_position
        
        next_position = calculate_position(next_position, dir_c)
      end

      if wall?(next_position, wall_hash)
        boxs.each do |box|
          box_hash[box] = nil
        end
      else
        boxs.each do |box|
          box_hash[calculate_position(box, dir_c)] = nil
        end
        robot_position = new_robot_position
      end
    elsif wall?(new_robot_position, wall_hash)
    else
      robot_position = new_robot_position
    end
  end
end

sum = 0

box_hash.keys.each do |line_index, column_index|
  sum += ((line_index * 100) + column_index)
end

puts sum

