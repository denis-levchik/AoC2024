require 'pry'

file = File.open("input.txt")
file_data = file.readlines.map(&:chomp)

sum = 0

while file_data.any?
  conditions = file_data.shift(4)

  a = conditions[0].scan(/X\+?(\d*), Y\+?(\d*)/).first.map(&:to_i)
  b = conditions[1].scan(/X\+?(\d*), Y\+?(\d*)/).first.map(&:to_i)
  result = conditions[2].scan(/X\=?(\d*), Y\=?(\d*)/).first.map { |number| number.to_i + 10_000_000_000_000 }

  n_div, n_mod = (result[1] * a[0] - a[1] * result[0]).divmod((b[1] * a[0] - a[1] * b[0]))

  if n_mod == 0
    m_div, m_mod = (result[0] - b[0] * n_div).divmod(a[0])

    if m_mod == 0
      sum += (m_div * 3 + n_div)
    end
  end
end

puts sum