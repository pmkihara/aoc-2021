# --- Day 5: Hydrothermal Venture ---
# x = column
# y = line

# ------------------------------ CHECK THE LINES -------------------------------
def vertical_line?(coordinate)
  #  start point x          end point x
  coordinate[0].first == coordinate[1].first
end

def horizontal_line?(coordinate)
  #  start point y         end point y
  coordinate[0].last == coordinate[1].last
end

def slash_line?(coordinate)
  #   start point x         end point x              start point y        end point y
  (coordinate[0].first - coordinate[1].first) == (coordinate[0].last - coordinate[1].last)
end

def backslash_line?(coordinate)
  #   start point x         end point x              start point y        end point y
  (coordinate[0].first - coordinate[1].first) == -(coordinate[0].last - coordinate[1].last)
end

# ------------------------------- DRAW THE LINES -------------------------------
def draw_vertical_line(coordinate, map)
  start_point = coordinate[0]
  end_point = coordinate[1]
  drawing_range = start_point.last < end_point.last ? (start_point.last)..(end_point.last) : (end_point.last)..(start_point.last)

  drawing_range.each do |number|
    key = "#{start_point.first},#{number}"
    map[key] += 1
  end
end

def draw_horizontal_line(coordinate, map)
  start_point = coordinate[0]
  end_point = coordinate[1]
  drawing_range = start_point.first < end_point.first ? (start_point.first)..(end_point.first) : (end_point.first)..(start_point.first)

  drawing_range.each do |number|
    key = "#{number},#{start_point.last}"
    map[key] += 1
  end
end

def draw_slash_line(coordinate, map)
  start_point = coordinate[0]
  end_point = coordinate[1]
  starting_x = start_point.first
  starting_y = start_point.last

  ((start_point.first - end_point.first).abs + 1).times do
    key = "#{starting_x},#{starting_y}"
    map[key] += 1
    if start_point.first < end_point.first
      # If the diagonal is downwards
      starting_x += 1
      starting_y += 1
    else
      # If the diagonal is upwards
      starting_x -= 1
      starting_y -= 1
    end
  end
end

def draw_backslash_line(coordinate, map)
  start_point = coordinate[0]
  end_point = coordinate[1]
  starting_x = start_point.first
  starting_y = start_point.last

  ((start_point.first - end_point.first).abs + 1).times do
    key = "#{starting_x},#{starting_y}"
    map[key] += 1
    if start_point.first < end_point.first
      # If the diagonal is upwards
      starting_x += 1
      starting_y -= 1
    else
      # If the diagonal is downwards
      starting_x -= 1
      starting_y += 1
    end
  end
end

# --- Part One ---
# Consider only horizontal (same y) and vertical (same x) lines. At how many points do at least two lines overlap?

def draw_simple_map(coordinates)
  map = Hash.new(0)
  coordinates.each do |coordinate|
    draw_vertical_line(coordinate, map) if vertical_line?(coordinate)
    draw_horizontal_line(coordinate, map) if horizontal_line?(coordinate)
  end
  puts "Overlaping horizontal and vertical lines: #{map.count { |entry| entry.last > 1 }}"
end

# --- Part Two ---
# You need to also consider diagonal lines

def draw_complete_map(coordinates)
  map = Hash.new(0)
  coordinates.each do |coordinate|
    draw_vertical_line(coordinate, map) if vertical_line?(coordinate)
    draw_horizontal_line(coordinate, map) if horizontal_line?(coordinate)
    draw_slash_line(coordinate, map) if slash_line?(coordinate)
    draw_backslash_line(coordinate, map) if backslash_line?(coordinate)
  end
  puts "Overlaping horizontal, vertical and diagonal lines: #{map.count { |entry| entry.last > 1 }}"
end


# SETUP - INPUT
input = File.read('inputs/day5_input.txt').lines.map { |line| line.to_s.strip.split(' -> ').map { |coord| coord.split(',').map(&:to_i) } }
puts '--- Part One ---'
draw_simple_map(input)
puts '--- Part Two ---'
draw_complete_map(input)

# SETUP - TEST
# test_input = File.read('inputs/day5_test.txt').lines.map { |line| line.to_s.strip.split(' -> ').map { |coord| coord.split(',').map(&:to_i) } }
# puts '--- Part One ---'
# draw_simple_map(test_input)
# puts '--- Part Two ---'
# draw_complete_map(test_input)
