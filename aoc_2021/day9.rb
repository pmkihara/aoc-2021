# SETUP - INPUT
input = File.read('inputs/day9_input.txt').lines.map { |line| line.to_s.strip.chars.map(&:to_i) }

# SETUP - TEST
test = File.read('inputs/day9_test.txt').lines.map { |line| line.to_s.strip.chars.map(&:to_i) }

def lower_than_left?(line, n_index)
  n_index.zero? ? true : line[n_index] < line[n_index - 1]
end

def lower_than_right?(line, n_index)
  n_index == (line.length - 1) ? true : line[n_index] < line[n_index + 1]
end

def lower_than_top?(array, l_index, number, n_index)
  l_index.zero? ? true : number < array[l_index - 1][n_index]
end

def lower_than_bottom?(array, l_index, number, n_index)
  l_index == (array.length - 1) ? true : number < array[l_index + 1][n_index]
end

def find_low_points(array)
  low_points = []
  array.each_with_index do |line, l_index|
    line.each_with_index do |number, n_index|
      low_points << number if lower_than_left?(line, n_index) && lower_than_right?(line, n_index) && lower_than_top?(array, l_index, number, n_index) && lower_than_bottom?(array, l_index, number, n_index)
    end
  end
  low_points
end

def total_risk_level(array)
  low_points = find_low_points(array)
  risk_sum = 0
  low_points.each { |point| risk_sum += (point + 1) }
  risk_sum
end

def find_low_points_position(array)
  low_points = []
  array.each_with_index do |line, l_index|
    line.each_with_index do |number, n_index|
      if lower_than_left?(line, n_index) && lower_than_right?(line, n_index) && lower_than_top?(array, l_index, number, n_index) && lower_than_bottom?(array, l_index, number, n_index)
        low_points << [n_index, l_index]
      end
    end
  end
  low_points
end

class Basin
  @@all = []
  def initialize(n_index, l_index)
    @n_index = n_index
    @l_index = l_index
    @visited = false
    @@all << self
  end

  def position
    [@n_index, @l_index]
  end

  def adj_positions
    [[@n_index - 1, @l_index], [@n_index + 1, @l_index], [@n_index, @l_index - 1], [@n_index, @l_index + 1]]
  end

  def visited?
    @visited
  end

  def visit!
    @visited = true
  end

  def self.all
    @@all
  end
end

def create_basins(array)
  array.each_with_index do |line, l_index|
    line.each_with_index do |number, n_index|
      Basin.new(n_index, l_index) unless number == 9
    end
  end
  Basin.all
end

def visit_basins(basin)
  pool = []
  basin.visit!
  pool << basin
  adjacent_basins = Basin.all.select { |b| basin.adj_positions.any?(b.position) && !b.visited? }
  if adjacent_basins.length.zero?
    pool.flatten.uniq
  else
    pool << adjacent_basins.map { |adj| pool << visit_basins(adj).flatten.uniq }.flatten.uniq
  end
end

def calculate(three_largest)
  lengths = three_largest.map(&:length)
  lengths.inject(:*)
end

def solve!(array)
  basins = create_basins(array)
  low_points_positions = find_low_points_position(array)
  low_points = low_points_positions.map { |position| basins.select { |basin| basin.position == position } }.flatten
  basin_pools = low_points.map { |point| visit_basins(point).flatten.uniq }
  three_largest = basin_pools.sort_by(&:length).reverse.first(3)
  calculate(three_largest)
end

# RESULTS
puts '--- Part One ---'
print 'Test - '
p total_risk_level(test)
print 'Input - '
p total_risk_level(input)
puts '--- Part Two ---'
print 'Test - '
p solve!(test)
print 'Input - '
p solve!(input)
