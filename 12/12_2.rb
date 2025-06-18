require 'pry'

DIRS_REGION = [
  [-1,0],
  [0,-1]
]

ALL_DIRS = [
  [-1,0],
  [0,1],
  [1,0],
  [0,-1]
]

NAME_DIRS = {
  [-1,0] => :up,
  [0,1] => :right,
  [1,0] => :down,
  [0,-1] => :left
}
file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

hash_region = {}

file_data.each_with_index do |line, line_index|
  line.chars.each_with_index do |value, column_index|
    if hash_region.key?(value)
      add_garden = false

      hash_region[value].each do |region|
        DIRS_REGION.each do |d_line, d_column|
          garden = [(line_index + d_line), (column_index + d_column)]
          
          if region.key?(garden)
            region[[line_index, column_index]] = nil
            add_garden = true
            break
          end
        end
      end

      hash_region[value] << { [line_index, column_index] => nil } unless add_garden
    else
      hash_region[value] = [ { [line_index, column_index] => nil } ]
    end
  end
end

hash_region.each do |_key, regions|
  if regions.count > 1
    2.times do
      i = 0

      while i < (regions.count - 1) do
        f = i + 1
  
        while f < (regions.count) do
          if (regions[i].keys & regions[f].keys).any?
            regions[i].merge!(regions[f])
            regions.delete_at(f)
          else
            f += 1
          end
        end
  
        i += 1
      end
    end
  end
end

sum = 0

hash_region.each do |_key, regions|
  regions.each do |region|
    square = region.count

    perimeter = 0
    perimeter_array = []

    region.keys.each do |line_index, column_index|
      ALL_DIRS.each do |d_line, d_column|
        garden = [(line_index + d_line), (column_index + d_column)] 
        unless region.key?(garden)
          perimeter += 1
          garden << NAME_DIRS[[d_line, d_column]]
          perimeter_array << garden
        end
      end
    end

    perimeter_array.combination(2) do |first, second|
      if first[2] == second[2]
        if [:up, :down].include?(first[2])
          if (first[0] == second[0]) && ((first[1] - second[1]).abs == 1)
            perimeter -= 1
          end
        else
          if (first[1] == second[1]) && ((first[0] - second[0]).abs == 1)
            perimeter -= 1
          end
        end
      end
    end

    sum += (square * perimeter)
  end
end

puts sum
