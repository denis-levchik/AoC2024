require 'pry'

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

all_pc = {}
all_pc_link = {}

file_data.each do |line|
  computers = line.split('-')

  computers.each do |computer|
    all_pc[computer] = nil
  end

  all_pc_link[[computers[0], computers[1]]] = nil
  # all_pc_link[[computers[1], computers[0]]] = nil
end

count = 0

all_pc.keys.combination(3).each do |computers|
  first, second, third = computers

  if first.start_with?('t') || second.start_with?('t') || third.start_with?('t')
    
    first_second = all_pc_link.key?([first, second]) || all_pc_link.key?([second, first])
    second_third = all_pc_link.key?([second, third]) || all_pc_link.key?([third, second])
    first_third  = all_pc_link.key?([first, third]) || all_pc_link.key?([third, first])

    count += 1 if first_second && second_third && first_third
  end
end

puts count
