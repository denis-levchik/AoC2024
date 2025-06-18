require 'pry'

def include_array?(array, x, y)
  array.key?([x,y])
end

def xmas?(m_arr, a_arr, s_arr, x, y, x_d, y_d)
  if include_array?(m_arr, (x+x_d), (y+y_d)) && include_array?(a_arr, (x+(2*x_d)), (y+(2*y_d))) && include_array?(s_arr, (x+(3*x_d)), (y+(3*y_d)))
    true 
  else
    false
  end
end

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

letters = {
  'X' => {},
  'M' => {},
  'A' => {},
  'S' => {}
}

file_data.each_with_index do |line, line_index|
  line.chars.each_with_index do |value, column_index|
    letters[value][[line_index, column_index]] = nil
  end
end

count = 0

letters['X'].keys.each_with_index do |a,i|
  puts i
  count += 1 if xmas?(letters['M'], letters['A'], letters['S'], a[0], a[1], 0, 1)
  count += 1 if xmas?(letters['M'], letters['A'], letters['S'], a[0], a[1], 1, 1)
  count += 1 if xmas?(letters['M'], letters['A'], letters['S'], a[0], a[1], 1, 0)
  count += 1 if xmas?(letters['M'], letters['A'], letters['S'], a[0], a[1], 1, -1)
  count += 1 if xmas?(letters['M'], letters['A'], letters['S'], a[0], a[1], 0, -1)
  count += 1 if xmas?(letters['M'], letters['A'], letters['S'], a[0], a[1], -1, 1)
  count += 1 if xmas?(letters['M'], letters['A'], letters['S'], a[0], a[1], -1, 0)
  count += 1 if xmas?(letters['M'], letters['A'], letters['S'], a[0], a[1], -1, -1)
end

puts(count)