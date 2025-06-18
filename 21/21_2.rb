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

def calculate_pattern(elements)
  robot_position = ROBOT_KEYPAD['A']
  result = []

  elements.chars.each do |char|
    char_position = ROBOT_KEYPAD[char]

    if robot_position == char_position
      result << 'A'
    else
      different_l = char_position[0] - robot_position[0]
      different_c = char_position[1] - robot_position[1]

      if different_c == 0 || different_l == 0
        if different_l > 0
          result << 'v' * different_l + 'A'
        elsif different_l < 0
          result << '^' * (different_l * -1) + 'A'
        end

        if different_c > 0
          result << '>' * different_c + 'A'
        elsif different_c < 0
          result << '<' * (different_c * -1) + 'A'
        end
      else
        if different_l > 0 && different_c > 0
          result << 'v' * different_c + '>' * different_l + 'A'
          # result << 'v' * different_l + '>' * different_c
        elsif different_l > 0 && different_c < 0
          if char_position == ROBOT_KEYPAD['<']
            result << 'v' * different_l + '<' * (different_c * (-1)) + 'A'
          else
            # result << 'v' * different_l + '<' * (different_c * (-1))
            result << '<' * (different_c * (-1)) + 'v' * different_l + 'A'
          end
        elsif different_l < 0 && different_c > 0
          if robot_position == ROBOT_KEYPAD['<']
            result << '>' * different_c + '^' * (different_l * (-1)) + 'A'
          else
            # result << '^' * (different_l * (-1)) + '>' * different_c
            result << '^' * different_c + '>' * (different_l * (-1)) + 'A'
          end
        elsif different_l < 0 && different_c < 0
          # result << '^' * (different_l * (-1)) + '<' * (different_c * (-1))
          result << '<' * (different_c * (-1)) + '^' * (different_l * (-1)) + 'A'
        end
      end

      # result << 'A'
      robot_position = char_position
    end
  end

  result
end

#way - hash
def robot_way(way, patterns_hash)
  new_way = {}

  way.each do |pattern, count|
    if patterns_hash.key?(pattern)
      patterns_hash[pattern].each do |element|
        if new_way.key?(element)
          new_way[element] += count
        else
          new_way[element] = count
        end
      end
    else
      new_pattern = calculate_pattern(pattern)

      patterns_hash[pattern] = new_pattern
      
      new_pattern.each do |element|
        if new_way.key?(element)
          new_way[element] += count
        else
          new_way[element] = count
        end
      end
    end
  end

  new_way
end

file = File.open("input_2.txt")
file_data = file.readlines.map(&:chomp)

count = 0
a_hash = {}

file_data.each do |line|
  first_ways = first_ways(line)
  
  min_count = 1_000_000_000_000_000_000
  
  gen0 = first_ways.map do |way|
    result = {}

    way.split('A').each do |line|
      new_line = line + 'A'
      if result.key?(new_line)
        result[new_line] += 1
      else
        result[new_line] = 1
      end
    end

    result
  end

  condition = true
  
  25.times do |i|
    # puts i
    gen1 = []

    while gen0.any? do
      way = gen0.shift

      gen1 << robot_way(way, a_hash)
    end

    gen0 = gen1
  end

  gen0.each do |last_way|
    sum = 0
    last_way.each do |pattern, count|
      sum += pattern.size * count
    end
    min_count = sum if sum < min_count
  end

  puts min_count

  count += line.scan(/\d*/).first.to_i * min_count
end

puts count
