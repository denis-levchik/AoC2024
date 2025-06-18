require 'pry'

def calculate_sequences(sequences, all_sequences)
  sequences.each do |sequence, price|
    if all_sequences.key?(sequence)
      all_sequences[sequence] += price
    else
      all_sequences[sequence] = price
    end
  end 
end

def calculate_result(number)
  first_step = ((number << 6) ^ number) & 16_777_215
  second_step = ((first_step >> 5) ^ first_step) & 16_777_215
  third_step = ((second_step << 11) ^ second_step) & 16_777_215
end

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

sum = 0

prices = []
all_sequences = {}

file_data.each do |line|
  number = line.to_i

  first_price = number % 10
  result = calculate_result(number)
  previous_price = result % 10

  different = [(previous_price - first_price)]
  sequences = {}

  1999.times do
    result = calculate_result(result)
    price = result % 10
    different << (price - previous_price)
    previous_price = price
    
    if different.count > 4
      different.shift
      unless sequences.key?(different)
        sequences[different.dup] = price
      end
    end
  end

  calculate_sequences(sequences, all_sequences)
end

puts all_sequences.values.max