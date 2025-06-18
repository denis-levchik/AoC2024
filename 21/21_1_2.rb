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

def first_ways(line)
  door_position = DOOR_KEYPAD['A']

  results = []

  line.chars.each do |char|
    char_position = DOOR_KEYPAD[char]
    all_options = []

    different_l = char_position[0] - door_position[0]
    different_c = char_position[1] - door_position[1]

    if different_c == 0 || different_l == 0
      if different_c > 0
        all_options << '>' * different_c
      elsif different_c < 0
        all_options << '<' * (different_c * -1)
      end
  
      if different_l > 0
        all_options << 'v' * different_l
      elsif different_l < 0
        all_options << '^' * (different_l * -1)
      end
    else
      if different_l > 0 && different_c > 0
        if door_position[1] == 0 && char_position[0] == 3
          all_options << '>' * different_c + 'v' * different_l
        else
          all_options << '>' * different_c + 'v' * different_l
          all_options << 'v' * different_l + '>' * different_c
        end
      elsif different_l > 0 && different_c < 0
        all_options << 'v' * different_l + '<' * (different_c * (-1))
        all_options << '<' * (different_c * (-1)) + 'v' * different_l
      elsif different_l < 0 && different_c > 0
        all_options << '^' * (different_l * (-1)) + '>' * different_c
        all_options << '>' * different_c + '^' * (different_l * (-1))
      elsif different_l < 0 && different_c < 0
        if door_position[0] == 3 && char_position[1] == 0
          all_options << '^' * (different_l * (-1)) + '<' * (different_c * (-1))
        else
          all_options << '^' * (different_l * (-1)) + '<' * (different_c * (-1))
          all_options << '<' * (different_c * (-1)) + '^' * (different_l * (-1))
        end
      end
    end

    all_options.map! { |option| option + 'A' }

    if results.any?
      new_results = []
      while results.any?
        result = results.shift

        all_options.each do |option|
          new_results << result + option
        end
      end

      results = new_results
    else
      results = all_options.dup
    end

    door_position = char_position
  end

  results
end

def robot_ways(way)
  robot_position = ROBOT_KEYPAD['A']

  results = []

  way.chars.each do |char|
    char_position = ROBOT_KEYPAD[char]
    all_options = []

    if robot_position == char_position
      all_options << ''
    else
      different_l = char_position[0] - robot_position[0]
      different_c = char_position[1] - robot_position[1]

      if different_c == 0 || different_l == 0
        if different_l > 0
          all_options << 'v' * different_l
        elsif different_l < 0
          all_options << '^' * (different_l * -1)
        end

        if different_c > 0
          all_options << '>' * different_c
        elsif different_c < 0
          all_options << '<' * (different_c * -1)
        end
      else
        if different_l > 0 && different_c > 0
          all_options << '>' * different_c + 'v' * different_l
          all_options << 'v' * different_l + '>' * different_c
        elsif different_l > 0 && different_c < 0
          if char_position == ROBOT_KEYPAD['<']
            all_options << 'v' * different_l + '<' * (different_c * (-1))
          else
            all_options << 'v' * different_l + '<' * (different_c * (-1))
            all_options << '<' * (different_c * (-1)) + 'v' * different_l
          end
        elsif different_l < 0 && different_c > 0
          if robot_position == ROBOT_KEYPAD['<']
            all_options << '>' * different_c + '^' * (different_l * (-1))
          else
            all_options << '^' * (different_l * (-1)) + '>' * different_c
            all_options << '>' * different_c + '^' * (different_l * (-1))
          end
        elsif different_l < 0 && different_c < 0
          all_options << '^' * (different_l * (-1)) + '<' * (different_c * (-1))
          all_options << '<' * (different_c * (-1)) + '^' * (different_l * (-1))
        end
      end
    end

    all_options.map! { |option| option + 'A' }

    if results.any?
      new_results = []
      while results.any?
        result = results.shift

        all_options.each do |option|
          new_results << result + option
        end
      end

      results = new_results
    else
      results = all_options.dup
    end

    robot_position = char_position
  end

  results
end

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

count = 0
file_data.each do |line|
  first_ways = first_ways(line)
  
  min_count = 1_000_000
  
  first_ways.each do |first_way|
    second_ways = robot_ways(first_way)

    second_ways.each do |second_way|
      third_ways = robot_ways(second_way)

      third_ways.each do |third_way|
        min_count = third_way.size if third_way.size < min_count
      end
    end
  end

  puts min_count

  count += line.scan(/\d*/).first.to_i * min_count
end

puts count
