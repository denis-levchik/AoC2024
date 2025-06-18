require 'pry'

DataInfo = Struct.new(:value, :count)
file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

state = true
number = 0
data_info_a = []

file_data.first.chars.each do |char|
  if state
    value = number
    number += 1
    state = false
  else
    value = '.'
    state = true
  end
  
  data_info_a << DataInfo.new(value, char.to_i)
end

check_sum = 0
i = 0

while data_info_a.any? do
  first ||= data_info_a.shift

  if first.value == '.'
    last ||= data_info_a.pop
    
    if last.value == '.'
      last = data_info_a.pop
    end

    if first.count == last.count
      last.count.times do
        check_sum += last.value * i
        i += 1
      end
      first = nil
      last = nil
    elsif first.count > last.count
      last.count.times do
        check_sum += last.value * i
        i += 1
      end

      first.count = first.count - last.count
      last = nil
    else
      first.count.times do
        check_sum += last.value * i
        i += 1
      end

      last.count = last.count - first.count
      first = nil
    end
  else
    first.count.times do
      check_sum += first.value * i
      i += 1
    end

    first = nil
  end
end

last.count.times do
  check_sum += last.value * i
  i += 1
end if last.kind_of?(DataInfo)

puts check_sum

