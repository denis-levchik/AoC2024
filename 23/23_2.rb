require 'pry'

def find_cycle(values, pc_links_for_one, current_best_size)
  count = values.count

  all_links = []

  values.each do |key|
    all_links << pc_links_for_one[key]
  end

  best_cycle = []

  while count >= current_best_size do
    all_links.combination(count).each do |combo|
      result = combo.shift

      while combo.any? do
        result &= combo.shift
      end

      best_cycle = result.dup if result.count == count + 1
    end

    count -= 1
  end

  best_cycle
end

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

pc_links_for_one = {}

file_data.each do |line|
  computers = line.split('-')

  if pc_links_for_one.key?(computers[0])
    pc_links_for_one[computers[0]] << computers[1]
  else
    pc_links_for_one[computers[0]] = computers.dup
  end

  if pc_links_for_one.key?(computers[1])
    pc_links_for_one[computers[1]] << computers[0]
  else
    pc_links_for_one[computers[1]] = computers.dup
  end
end

best = ['aa']

pc_links_for_one.keys.each do |key|
  values = pc_links_for_one[key].dup
  values.delete(key)

  cycle = find_cycle(values, pc_links_for_one, best.count)

  if cycle.count > best.count
    best = cycle
  end
end

puts best.sort.join(',')
