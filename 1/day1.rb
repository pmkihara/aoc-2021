# Read the file
input = File.read('inputs/day1_input.txt').lines.map(&:to_i)
test = %w(199
          200
          208
          210
          200
          207
          240
          269
          260
          263).map(&:to_i)

# --- Part One ---
def depth_increase(data)
  depth_increase = 0
  data.each_with_index do |depth, index|
    next if index.zero?

    depth_increase += 1 if depth > data[index - 1]
  end
  puts "[Part One] Depth increase = #{depth_increase}"
end

# --- Part Two ---
def window_depth_increase(data)
  window_depth_increase = 0
  data.each_with_index do |_depth, index|
    next if index >= data.length - 3

    # Separate the windows
    first_trio = data[index] + data[index + 1] + data[index + 2]
    second_trio = data[index + 1] + data[index + 2] + data[index + 3]

    # Calculate increase
    window_depth_increase += 1 if first_trio < second_trio
  end
  puts "[Part Two] Window depth increase = #{window_depth_increase}"
end

depth_increase(input)
window_depth_increase(input)
depth_increase(test)
window_depth_increase(test)
