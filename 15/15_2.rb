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
  box_hash.key?(position) || box_hash.key?([position[0], (position[1] - 1)])
end

def box_start(position, box_start_hash)
  if box_start_hash.key?(position)
    position
  elsif box_start_hash.key?([position[0], (position[1] - 1)])
    [position[0], (position[1] - 1)]
  else
    []
  end
end

def next_positions(boxs_start)
  next_positions = []
  boxs_start.each do |box|
    next_positions << box
    next_positions << [box[0], (box[1] + 1)]
  end

  next_positions
end

# def show_picture(wall_hash, box_start_hash, robot_position, dir)
#   start_picture = []

#   10.times do
#     start_picture << Array.new(20, '.')
#   end

#   start_picture

#   wall_hash.keys.each do |wall|
#     start_picture[wall[0]][wall[1]] = '#'
#   end

#   box_start_hash.keys.each do |start|
#     start_picture[start[0]][start[1]] = '['
#     start_picture[start[0]][(start[1]+1)] = ']'
#   end

#   start_picture[robot_position[0]][robot_position[1]] = '@'

#   puts dir
#   puts
#   start_picture.each do |line|
#     puts(line.join)
#   end
# end

def wall?(position, wall_hash)
  wall_hash.key?(position)
end

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

line = file_data.shift
line_index = 0

robot_position = nil
box_start_hash = {}
box_end_hash = {}
wall_hash = {}

while !line.empty? do
  column_index = -1

  line.chars.each do |value|
    if value == '@'
      robot_position = [line_index, column_index += 1]
      column_index += 1
    elsif value == 'O'
      box_start_hash[[line_index, column_index += 1]] = nil
      box_end_hash[[line_index, column_index += 1]] = nil
    elsif value == '#'
      wall_hash[[line_index, column_index += 1]] = nil
      wall_hash[[line_index, column_index += 1]] = nil
    else
      column_index += 2
    end
  end

  line_index += 1
  line = file_data.shift
end

# show_picture(wall_hash, box_start_hash, robot_position, 0)

file_data.each do |dirs|
  dirs.chars.each do |dir|
    dir_c = DIRS[dir]

    new_robot_position = calculate_position(robot_position, dir_c)

    box_start = box_start(new_robot_position, box_start_hash)
    if box_start.any?
      if ['^', 'v'].include?(dir)
        box_start_hash.delete(box_start)
        boxs = [box_start]
        current_positions = next_positions([box_start])
        wall_present = false

        while current_positions.any? do
          next_position = calculate_position(current_positions.shift, dir_c)

          box_start = box_start(next_position, box_start_hash)

          if box_start.any?
            box_start_hash.delete(box_start)
            boxs << box_start
            current_positions.push(*next_positions([box_start]))
          elsif wall?(next_position, wall_hash)
            wall_present = true
            break
          end
        end

        if wall?(next_position, wall_hash) || wall_present
          boxs.each do |box|
            box_start_hash[box] = nil
          end
        else
          boxs.each do |box|
            box_start_hash[calculate_position(box, dir_c)] = nil
          end
          robot_position = new_robot_position
        end
      else
        box_start_hash.delete(box_start)
        boxs = [box_start]
        
        if box_start == new_robot_position
          next_position = calculate_position([box_start[0], (box_start[1] + 1)], dir_c)
        else
          next_position = calculate_position(box_start, dir_c)
        end

        box_start = box_start(next_position, box_start_hash)
  
        while box_start.any? do
          box_start_hash.delete(box_start)
          boxs << box_start
          
          if box_start == next_position
            next_position = calculate_position([box_start[0], (box_start[1] + 1)], dir_c)
          else
            next_position = calculate_position(box_start, dir_c)
          end
          box_start = box_start(next_position, box_start_hash)
        end
  
        if wall?(next_position, wall_hash)
          boxs.each do |box|
            box_start_hash[box] = nil
          end
        else
          boxs.each do |box|
            box_start_hash[calculate_position(box, dir_c)] = nil
          end
          robot_position = new_robot_position
        end
      end
    elsif wall?(new_robot_position, wall_hash)
    else
      robot_position = new_robot_position
    end

    # show_picture(wall_hash, box_start_hash, robot_position, dir)
  end
end

sum = 0

box_start_hash.keys.each do |line_index, column_index|
  sum += ((line_index * 100) + column_index)
end

puts sum