require 'pry'

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

hash_patterns = {}
max_pattern_size = nil
min_pattern_size = nil

file_data.shift.split(',').each do |pattern|
  pattern = pattern.strip
  hash_patterns[pattern] = nil

  if !min_pattern_size.kind_of?(Integer) || min_pattern_size > pattern.size
    min_pattern_size = pattern.size
  end

  if !max_pattern_size.kind_of?(Integer) || max_pattern_size < pattern.size
    max_pattern_size = pattern.size
  end
end

file_data.shift

count = 0

file_data.each_with_index do |design, i|
  gen0 = {} 
  gen0[design] = 1
  gen1 = {}

  condition = false
  loop do
    gen1 = {}

    while gen0.any? do
      line, value = gen0.shift
      # puts line
      # puts '/////////////'
      line_size = line.size
  
      (min_pattern_size..max_pattern_size).each do |count_letter|
        next if (count_letter) > line_size
        design = line[0..(count_letter - 1)]
  
        if hash_patterns.key?(design)
          # puts design
          if line == design
            count += value
          else
            new_line = line[(count_letter)..-1]
            if gen1.key?(new_line)
              gen1[new_line] += value
            else
              gen1[new_line] = value
            end
          end
        end
      end
    end

    if gen1.any?
      gen0 = gen1
    else
      break
    end
  end

  count += 1 if condition
end

puts count