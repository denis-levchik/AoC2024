require 'pry'

CYCLE = 100
MAX_X = 101
MAX_Y = 103

def start_picture
  start_picture = []

  MAX_Y.times do
    start_picture << Array.new(MAX_X, '.')
  end

  start_picture
end

def show_picture(picture)
  picture.each do |line|
    puts(line.join)
  end

  true
end

file = File.open("input_2.txt")
file_data = file.readlines.map(&:chomp)

middle_x = MAX_X/2
middle_y = MAX_Y/2

old_robots = []

file_data.each do |line|
  old_robots << line.scan(/p\=?(\-?\d*),?(\-?\d*) v=?(\-?\d*),?(\-?\d*)/).first.map(&:to_i)
end

i = 0

loop do
  new_robots = []
  new_picture = start_picture

  all_position = []

  while old_robots.any? do
    p_x, p_y, v_x, v_y = old_robots.shift

    new_x = (p_x + v_x) % MAX_X
    new_y = (p_y + v_y) % MAX_Y

    new_picture[new_y][new_x] = 'x'
    all_position << [new_y, new_x]

    new_robots << [new_x, new_y, v_x, v_y]
  end

  old_robots = new_robots
  i += 1

  
  binding.pry if all_position.count == all_position.uniq.count
end