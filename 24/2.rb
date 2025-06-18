# OPS = {
#   AND: ->(a, b){ a & b },
#   OR:  ->(a, b){ a | b },
#   XOR: ->(a, b){ a ^ b }
# }
values, gates = ARGF.read.chomp.split("\n\n")

wires = values.split("\n").to_h do |line|
  wire, value = line.split(': ')
  [wire, value.to_i]
end

gates = gates.split("\n").to_h do |line|
  input, output = line.split(' -> ')
  wire1, op, wire2 = input.split
  # [[wire1, op, wire2, output], nil]
  [[wire1, wire2, op].sort, output]
end

x = wires.keys.select { _1[0] == 'x' }.sort.reverse.map { wires[_1].to_s }.join.to_i(2)
y = wires.keys.select { _1[0] == 'y' }.sort.reverse.map { wires[_1].to_s }.join.to_i(2)
sum = x + y

# puts gates.size
# jsq AND vcj -> shh
# jsq XOR vcj -> z21
key1 = %w[jsq AND vcj].sort
key2 = %w[jsq XOR vcj].sort
gates[key1], gates[key2] = gates[key2], gates[key1]

# y26 XOR x26 -> vgs
# y26 AND x26 -> dtk
key1 = %w[y26 XOR x26].sort
key2 = %w[y26 AND x26].sort
gates[key1], gates[key2] = gates[key2], gates[key1]

# mtw OR fdv -> dqr
# vkp XOR jqp -> z33
key1 = %w[mtw OR fdv].sort
key2 = %w[vkp XOR jqp].sort
gates[key1], gates[key2] = gates[key2], gates[key1]

# gqn XOR sjq-> z39
# x39 AND y39 -> pfw
key1 = %w[gqn XOR sjq].sort
key2 = %w[x39 AND y39].sort
gates[key1], gates[key2] = gates[key2], gates[key1]

def zhopa?(w, m)
  if w.nil? || w[0] == 'z'
    puts w
    puts "Zhopa w#{m}: #{w.inspect}"
    exit
  # else
  #   puts "w#{m}: #{w}"
  end
end

i = 1
cin = 'mcg'
while i < 44 do
  # puts "#{i}: "
  idx = i.to_s.rjust(2, '0')
  xi = 'x' + idx
  yi = 'y' + idx
  zi = 'z' + idx

  w1 = gates[[xi, yi, 'XOR'].sort]
  zhopa?(w1, '1')

  w2 = cin
  zhopa?(w2, '2')
  w4 = gates[[xi, yi, 'AND'].sort]
  puts xi
  puts yi
  zhopa?(w4, '4')
  w3 = gates[[w1, w2, 'AND'].sort]
  zhopa?(w3, '3')
  w5 = gates[[w3, w4, 'OR'].sort]
  zhopa?(w5, '5')

  w6 = gates[[w1, w2, 'XOR'].sort]
  if w6.nil? || w6 != zi
    puts "Zhopa 6"
    exit
  # else
  #   puts "w#{m}: #{w}"
  end


  # puts "--- OK"
  cout = w5
  cin = cout

  i += 1
end
puts 'Bingo!'

# jsq AND vcj -> shh
# jsq XOR vcj -> z21
# y26 XOR x26 -> vgs
# y26 AND x26 -> dtk
# mtw OR fdv -> dqr
# vkp XOR jqp -> z33
# gqn XOR sjq-> z39
# x39 AND y39 -> pfw
names = %w[shh z21 vgs dtk dqr z33 z39 pfw].sort.join(',')

puts "The names of the eight wires involved in a swap: #{names}"
