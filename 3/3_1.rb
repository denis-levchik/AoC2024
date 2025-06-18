file = File.open("input.txt")
file_data = file.readlines

sum = 0

file_data.each do |line|
  line.scan(/mul\(?(\d*),?(\d*)\)/) do |x, y|
    sum += x.to_i * y.to_i
  end
end

puts sum