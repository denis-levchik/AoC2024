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
  puts i
  lines = {}
  lines[design] = nil

  condition = false

  while lines.any? do
    line, _value = lines.shift
    # puts line
    # puts '/////////////'
    line_size = line.size

    (min_pattern_size..max_pattern_size).each do |count_letter|
      next if (count_letter) > line_size
      design = line[0..(count_letter - 1)]

      if hash_patterns.key?(design)
        # puts design
        if line == design
          condition = true
          break
        else
          lines[line[(count_letter)..-1]] = nil
        end
      end
    end
  end

  count += 1 if condition
end

puts count