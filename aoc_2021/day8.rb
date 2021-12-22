# SETUP - INPUT
input = File.read('inputs/day8_input.txt').lines.map { |line| line.to_s.strip.split(' | ').map { |entry| entry.split(' ') } }

# SETUP - TEST
test = File.read('inputs/day8_test.txt').lines.map { |line| line.to_s.strip.split(' | ').map { |entry| entry.split(' ') } }

def number_of_1_4_7_8(array)
  count = 0
  array.each do |entry|
    output = entry.last
    count += (output.select { |digit| digit.length == 2 || digit.length == 3 || digit.length == 4 || digit.length == 7 }.length)
  end
  puts "Count: #{count}"
end

def get_digits(entry)
  entry_chars = entry.map { |digit| digit.chars.sort }
  digits = {
    1 => entry_chars.select { |char| char.length == 2 }.first,
    4 => entry_chars.select { |char| char.length == 4 }.first,
    7 => entry_chars.select { |char| char.length == 3 }.first,
    8 => entry_chars.select { |char| char.length == 7 }.first
  }
  segments = {}
  segments['e'] = entry_chars.flatten.tally.select { |_k, v| v == 4 }.flatten.first
  segments['f'] = entry_chars.flatten.tally.select { |_k, v| v == 9 }.flatten.first
  segments['c'] = (digits[1] - [segments['f']]).first
  segments['a'] = (digits[7] - [(segments['c']), (segments['f'])]).first
  digits[9] = entry_chars.select { |char| char.length == 6 && char.none?(segments['e']) }.first
  digits[6] = entry_chars.select { |char| char.length == 6 && char.none?(segments['c']) }.first
  digits[0] = (entry_chars.select { |char| char.length == 6 } - [digits[6], digits[9]]).first
  segments['d'] = (digits[8] - digits[0]).first
  digits[3] = entry_chars.select { |char| char.length == 5 && char.any?(segments['c']) && char.any?(segments['f']) }.first
  segments['g'] = digits[3] - digits[7] - [segments['d']]
  digits[5] = digits[8] - [segments['c'], segments['e']]
  digits[2] = entry_chars.select { |char| char.length == 5 && char.any?(segments['c']) && char.any?(segments['e']) }.first
  digits
end

def decode_numbers(entry)
  digits = get_digits(entry.first)
  entry.last.map(&:chars).map { |number| digits.key(number.sort) }.join.to_i
end

def sum_outputs(array)
  output_sum = array.map { |entry| decode_numbers(entry) }
  puts "Total sum: #{output_sum.sum}"
end

# RESULTS
puts '--- Part One ---'
print 'Test - '
number_of_1_4_7_8(test)
print 'Input - '
number_of_1_4_7_8(input)
puts '--- Part Two ---'
print 'Test - '
sum_outputs(test)
print 'Input - '
sum_outputs(input)
