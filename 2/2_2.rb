require 'pry'

def broken?(numbers)
  numbers_length = numbers.length

  condition = true
  dynamic = true
  is_broken = false

  numbers_length.times do |i|
    next if i == (numbers_length - 1)

    current = numbers[i]
    future = numbers[i + 1]
    different = future - current

    if i == 0
      dynamic = different > 0
    end

    unless ((1..3).include?(different) && dynamic) || ((-3..-1).include?(different) && !dynamic)
      is_broken = true
      break
    end
  end

  is_broken
end

file = File.open("input.txt")
file_data = file.readlines

count = 0

file_data.each do |line|
  numbers = line.chomp.split.map(&:to_i)

  is_broken = broken?(numbers)

  if is_broken
    numbers.length.times do |i|
      numbers_v2 = numbers.dup
      numbers_v2.delete_at(i)
      is_broken = broken?(numbers_v2)

      unless is_broken
        count += 1
        break
      end
    end
  else
    count += 1
  end
end

puts count