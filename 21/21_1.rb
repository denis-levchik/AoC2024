require 'pry'

DOOR_KEYPAD = {
  '7' => [0,0],
  '8' => [0,1],
  '9' => [0,2],
  '4' => [1,0],
  '5' => [1,1],
  '6' => [1,2],
  '1' => [2,0],
  '2' => [2,1],
  '3' => [2,2],
  '0' => [3,1],
  'A' => [3,2]
}

ROBOT_KEYPAD = {
  '^' => [0,1],
  'A' => [0,2],
  '<' => [1,0],
  'v' => [1,1],
  '>' => [1,2]
}

def first_way(line)
  door_position = DOOR_KEYPAD['A']

  result = ''
  line.chars.each do |char|
    char_position = DOOR_KEYPAD[char]

    different_l = char_position[0] - door_position[0]
    different_c = char_position[1] - door_position[1]

    if different_l > 0 && different_c > 0
      result << '>' * different_c
      result << 'v' * different_l
    elsif different_l > 0 && different_c < 0
      result << 'v' * different_l
      result << '<' * (different_c * (-1))
    elsif different_l < 0 && different_c > 0
      result << '^' * (different_l * (-1))
      result << '>' * different_c
    elsif different_l < 0 && different_c < 0
      if door_position[0] == 3 && char_position[1] == 0
        result << '^' * (different_l * (-1))
        result << '<' * (different_c * (-1))
      else
        result << '<' * (different_c * (-1))
        result << '^' * (different_l * (-1))
      end
    else
      if different_c > 0
        result << '>' * different_c
      elsif different_c < 0
        result << '<' * (different_c * -1)
      end
  
      if different_l > 0
        result << 'v' * different_l
      elsif different_l < 0
        result << '^' * (different_l * -1)
      end
    end

    door_position = char_position
    result << 'A'
  end
  result
end

def robot_way(way)
  robot_position = ROBOT_KEYPAD['A']

  result = ''
  way.chars.each do |char|
    char_position = ROBOT_KEYPAD[char]

    if robot_position == char_position
      result << 'A'
    else
      different_l = char_position[0] - robot_position[0]
      different_c = char_position[1] - robot_position[1]

      if char_position[0] == 1
        if different_l > 0
          result << 'v' * different_l
        elsif different_l < 0
          result << '^' * (different_l * -1)
        end

        if different_c > 0
          result << '>' * different_c
        elsif different_c < 0
          result << '<' * (different_c * -1)
        end
      else
        if different_c > 0
          result << '>' * different_c
        elsif different_c < 0
          result << '<' * (different_c * -1)
        end
    
        if different_l > 0
          result << 'v' * different_l
        elsif different_l < 0
          result << '^' * (different_l * -1)
        end
      end
  
      robot_position = char_position
      result << 'A'
    end
  end

  result
end

file = File.open("test.txt")
file_data = file.readlines.map(&:chomp)

count = 0
file_data.each do |line|
  first_way = first_way(line)
  second_way = robot_way(first_way)
  third_way = robot_way(second_way)

  count += line.scan(/\d*/).first.to_i * third_way.size
  puts third_way.size
end

puts count

