# SETUP - INPUT
input = File.read('inputs/day7_input.txt').lines.first.strip.split(',').map(&:to_i)

# SETUP - TEST
test = [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]

def find_closest_point(array)
  # Find the median (mediana) point in the array
  array = array.sort
  middle_point = (array.length / 2) - 1

  array.length.odd? ? (array[middle_point] + array[middle_point + 1]) / 2 : array[middle_point]
end

def calculate_fuel(array)
  closest_point = find_closest_point(array)
  total_fuel = 0
  puts "Closest point: #{closest_point} / Total fuel: #{total_fuel}"
end

def advanced_calculate_fuel(array)
  array = array.sort
  total_fuel = Hash.new(0)
  ((array.min)..(array.max)).each do |possible_position|
    array.each do |position|
      distance = (position - possible_position).abs
      fuel = (distance * (1 + distance)) / 2 # Sum of the arythmetic progression
      total_fuel[possible_position] += fuel
    end
  end
  fewer_fuel = total_fuel.sort_by { |_k, v| v }
  puts "Closest point: #{fewer_fuel.first.first} / Total fuel: #{fewer_fuel.first.last}"
end

puts '--- Part One ---'
print 'Test - '
calculate_fuel(test)
print 'Input - '
calculate_fuel(input)
puts '--- Part Two ---'
print 'Test - '
advanced_calculate_fuel(test)
print 'Input - '
advanced_calculate_fuel(input)
