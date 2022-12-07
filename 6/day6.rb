# --- Day 6: Lanternfish ---

def set_future_sea(fish_array, days)
  # Create a new hash:
  # Key = days left
  # Value = Number of fish
  all_fishes = {
    0 => 0,
    1 => 0,
    2 => 0,
    3 => 0,
    4 => 0,
    5 => 0,
    6 => 0,
    7 => 0,
    8 => 0,
    9 => 0
  }
  fish_array.each { |fish| all_fishes[fish] += 1 }
  days.times do
    #                   days left, number of fish
    all_fishes.each do |key, value|
      if key.zero?
        # remove all the fishes from day 0
        all_fishes[0] -= value
        # add the fishes to day 6
        all_fishes[7] += value
        # create new fishes on day 8
        all_fishes[9] += value
      else
        all_fishes[key] -= value
        all_fishes[key - 1] += value
      end
    end
  end
  p all_fishes
  puts "Day #{days}: #{all_fishes.values.sum} fishes"
end

# SETUP - INPUT
input = File.read('inputs/day6_input.txt').lines.first.strip.split(',').map(&:to_i)
# puts '--- Part One ---'
# set_future_sea(input, 80)
# puts '--- Part Two ---'
set_future_sea(input, 256)

# SETUP - TEST
# test = [3, 4, 3, 1, 2]
# set_future_sea(test, 18)
# set_future_sea(test, 256)
