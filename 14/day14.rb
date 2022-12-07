# SETUP - INPUT
input = File.read('inputs/day14_input.txt').lines.map { |line| line.strip.split(' -> ') }.group_by(&:length)

# SETUP - EXAMPLE
# input = File.read('inputs/day14_example.txt').lines.map { |line| line.strip.split(' -> ') }.group_by(&:length)

def input_keys(keys)
  result = {}
  keys.each { |key| result[key[0].chars] = key[1] }
  result
end

def solve!(input)
  template = input[1].join
  input_keys = input_keys(input[2])

  # Separate and count template pairs
  pairs = template.chars.each_cons(2).tally
  pairs.default = 0

  # Change the number of times depending on which part of the challenge
  40.times do
    next_pairs = Hash.new(0)

    # Get each pair in the counter
    pairs.each do |pair, tally|
      # Get the corresponding next pairs
        next_pairs[[pair[0], input_keys[pair]]] += tally
        next_pairs[[input_keys[pair], pair[1]]] += tally
    end
    pairs = next_pairs
  end

  # The final string is the first letter of each pair + the last letter of the template
  char_count = Hash.new(0)
  pairs.each do |(first, last), tally|
    char_count[first] += tally
  end
  char_count[template.chars.last] += 1

  # Get the min and max values
  min_max = char_count.minmax_by { |pair| pair.last }

  # Answer: most common (max) - least common (min)
  max = min_max.last.last
  min = min_max.first.last
  p max - min
end

solve!(input)
