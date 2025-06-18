require 'pry'

file = File.open("input_2.txt")
file_data = file.readlines

count = 0

file_data.each do |line|
  numbers = line.chomp.split.map(&:to_i)

  condition = true
  dynamic = true

  numbers.length.times do |i|
    next if i == 0

    current = numbers[i]
    previous = numbers[i - 1]
    different = current - previous

    if i == 1
      dynamic = different > 0
    end

    unless ((1..3).include?(different) && dynamic) || ((-3..-1).include?(different) && !dynamic)
      condition = false
      break
    end
  end

  count += 1 if condition
end

puts count