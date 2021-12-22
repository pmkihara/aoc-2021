# Read the file
input = File.read('inputs/day2_input.txt').lines.map
test = ['forward 5', 'down 5', 'forward 8', 'up 3', 'down 8', 'forward 2']

# --- Part One ---
def calc_position(data)
  horizontal_position = 0
  depth = 0

  data.each do |command|
    # Separate the command into the word and the number
    direction = command.split.first
    number = command.split.last.to_i

    # Calculate the position
    case direction
    when 'forward' then horizontal_position += number
    when 'down' then depth += number
    when 'up' then depth -= number
    end
  end
  puts "Horizontal position: #{horizontal_position} / Depth: #{depth}"
  puts "Multiplied = #{horizontal_position * depth}"
end

# --- Part Two ---
def calc_position_with_aim(data)
  horizontal_position = 0
  depth = 0
  aim = 0

  data.each do |command|
    # Separate the command into the word and the number
    direction = command.split.first
    number = command.split.last.to_i

    # Calculate the position
    case direction
    when 'forward'
      horizontal_position += number
      depth += aim * number
    when 'down' then aim += number
    when 'up' then aim -= number
    end
  end
  puts "Horizontal position: #{horizontal_position} / Depth: #{depth}"
  puts "Multiplied = #{horizontal_position * depth}"
end

# Call the functions
puts '[Part One]'
calc_position(test)
calc_position(input)
puts '-----------'
puts '[Part Two]'
calc_position_with_aim(test)
calc_position_with_aim(input)
