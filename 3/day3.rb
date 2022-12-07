# --- Day 3: Binary Diagnostic ---

# Read the file
input = File.read('inputs/day3_input.txt').lines.map
# test = %w[00100 11110 10110 10111 10101 01111 00111 11100 10000 11001 00010 01010]

# --- Part One ---
# What is the power consumption of the submarine?

def get_split_digits_frequency(array)
  split_digits = []
  index = 0
  until index == array.first.length do
    split_digits << array.map { |n| n[index] }.tally
    index += 1
  end
  split_digits
end

def get_gamma(array)
  split_digits = get_split_digits_frequency(array)
  binary_gamma = []
  split_digits.each do |digits|
    binary_gamma << digits.max_by { |_key, value| value }.first
  end
  # puts "Binary gamma: #{binary_gamma.join}"
  # puts "Decimal gamma: #{binary_gamma.join.to_s.to_i(2)}"
  binary_gamma.join.to_s.to_i(2)
end

def get_epsilon(array)
  split_digits = get_split_digits_frequency(array)
  binary_epsilon = []
  split_digits.each do |digits|
    binary_epsilon << digits.min_by { |_key, value| value }.first
  end
  # puts "Binary epsilon: #{binary_epsilon.join}"
  # puts "Decimal epsilon: #{binary_epsilon.join.to_s.to_i(2)}"
  binary_epsilon.join.to_s.to_i(2)
end

def get_power_consuption(array)
  gamma = get_gamma(array)
  epsilon = get_epsilon(array)
  puts "Power Consuption: #{gamma * epsilon}"
end

# --- Part Two ---

def get_oxygen_generator_rating(array)
  new_array = array
  index = 0

  until new_array.count == 1
    # Get new digits frequency
    digits = get_split_digits_frequency(new_array)[index]

    # Select the numbers with biggest frequency
    new_array = digits['1'] >= digits['0'] ? new_array.select { |n| n[index] == '1' } : new_array.select { |n| n[index] == '0' }

    # Increase the index
    index += 1
  end
  puts "Oxygen generator rating (decimal): #{new_array.first.to_i(2)}"
  new_array.first.to_i(2)
end

def get_co2_generator_rating(array)
  new_array = array
  index = 0

  until new_array.count == 1
    # Get new digits frequency
    digits = get_split_digits_frequency(new_array)[index]

    # Select the numbers with biggest frequency
    new_array = digits['0'] <= digits['1'] ? new_array.select { |n| n[index] == '0' } : new_array.select { |n| n[index] == '1' }

    # Increase the index
    index += 1
  end
  puts "CO2 generator rating (decimal): #{new_array.first.to_i(2)}"
  new_array.first.to_i(2)
end

def get_life_support_rating(array)
  oxygen = get_oxygen_generator_rating(array)
  co2 = get_co2_generator_rating(array)
  puts "Life support rating (decimal): #{oxygen * co2}"
end

puts '--- Part One ---'
get_power_consuption(input)
puts '----------------'
puts '--- Part Two ---'
get_life_support_rating(input)
