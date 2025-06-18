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
  
  data_info_a << DataInfo.new(value, char.to_i) unless char.to_i.zero?
end

last_i = data_info_a.count - 1

while last_i > 0 do
  last = data_info_a[last_i].dup

  if last.value != '.'
    first_i = nil
    first = data_info_a.find.with_index do |info, index|
      if index < last_i && info.value == '.' && info.count >= last.count
        first_i = index
      else
        false
      end
    end

    if first.kind_of?(DataInfo)
      data_info_a[last_i].value = '.'
      data_info_a.insert(first_i, last)

      if first.count == last.count
        data_info_a.delete_at(first_i + 1)
      else
        data_info_a[first_i + 1].count = data_info_a[first_i + 1].count - last.count
      end
    else
      last_i -= 1
    end
  else
    last_i -= 1
  end
end

i = 0
check_sum = 0

data_info_a.each do |info|
  if info.value != '.'
    info.count.times do
      check_sum += info.value.to_i * i
      i += 1
    end
  else
    i += info.count
  end
end

puts check_sum

