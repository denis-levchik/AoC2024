require 'pry'

def algorithm(a)
  b = a % 8
  b = b ^ 1
  c = a >> b
  b = b ^ c
  b = b ^ 4

  b % 8
end

program = [2,4,1,1,7,5,4,4,1,4,0,3,5,5,3,0]

queue = program.reverse
count = queue.count
gen0 = [0]
a = 0

while queue.any?
  number = queue.shift
  gen1 = []

  gen0.each do |a|
    a *= 8

    8.times do |i|
      result = algorithm(a + i)

      gen1 << (a + i) if result == number
    end
  end

  gen0 = gen1

  # a *= 8
  # number = queue.shift

  # i = 0
  # loop do
  #   result = algorithm(a + i)

  #   if result == number
  #     a = (a + i)
  #     break
  #   end

  #   i += 1
  # end
end

puts gen0.min
