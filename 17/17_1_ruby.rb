require 'pry'

a = 12061990
b = 0
c = 0

output = []

# program = [2,4,1,1,7,5,4,4,1,4,0,3,5,5,3,0]

loop do
  b = a % 8
  b = b ^ 1
  c = a >> b
  b = b ^ c
  b = b ^ 4
  a = a / 8

  output << (b % 8)
  
  break if a == 0
end

puts output.join(',')