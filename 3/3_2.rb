require 'pry'

file = File.open("input.txt")
file_data = file.readlines

sum = 0
condition = true

file_data.each do |line|
  line.scan(/(mul\(?(\d*),?(\d*)\))|(do\(\))|(don't\(\))/) do |_v, x, y, do_match, dont_match|

    if do_match.kind_of?(String)
      condition = true
    elsif dont_match.kind_of?(String)
      condition = false
    else
      sum += x.to_i * y.to_i if condition
    end
  end
end

puts sum