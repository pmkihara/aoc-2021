# SETUP - INPUT
input = File.read('inputs/day11_input.txt').lines.map { |line| line.strip.to_i.digits.reverse }

# SETUP - TEST
test = File.read('inputs/day11_example.txt').lines.map { |line| line.strip.to_i.digits.reverse }

# Instantiates the Octopuses
class Octopus
  attr_reader :energy

  @@all = []

  def initialize(energy, x_index, y_index)
    @energy = energy
    @y_index = y_index
    @x_index = x_index
    @flashed = false
    @increased = false
    @@all << self
  end

  def position
    [@y_index, @x_index]
  end

  def adjacents
    [
      [@y_index - 1, @x_index - 1], # top left
      [@y_index - 1, @x_index], # top
      [@y_index - 1, @x_index + 1], # top right
      [@y_index, @x_index - 1], # left
      [@y_index, @x_index + 1], # right
      [@y_index + 1, @x_index - 1], # bottom left
      [@y_index + 1, @x_index], # bottom
      [@y_index + 1, @x_index + 1] # bottom right
    ]
  end

  def increase_energy!
    @energy += 1
    flash! if @energy > 9
  end

  def flashed?
    @flashed
  end

  def flash!
    @flashed = true
  end

  def reset!
    @flashed = false
    @increased = false
    @energy = 0
  end

  def increased_adjs?
    @increased
  end

  def increase_adjs!
    @increased = true
  end

  def self.all
    @@all
  end
end

def next_step!
  octopuses = Octopus.all
  octopuses.each(&:increase_energy!)
  until octopuses.select { |octopus| octopus.flashed? && !octopus.increased_adjs? }.length.zero?
    can_flash = octopuses.select { |octopus| octopus.flashed? && !octopus.increased_adjs? }
    can_flash.each do |flashed|
      adjs = octopuses.select { |octopus| flashed.adjacents.include?(octopus.position) }
      adjs.each(&:increase_energy!)
      flashed.increase_adjs!
    end
  end
end

def solve_part_1!(input)
  input.each_with_index do |line, y_index|
    line.each_with_index do |value, x_index|
      Octopus.new(value, x_index, y_index)
    end
  end

  flashes = 0
  100.times do
    next_step!
    flashed = Octopus.all.select(&:flashed?)
    flashed.each(&:reset!)
    flashes += flashed.length
  end
  puts flashes
end

def solve_part_2!(input)
  input.each_with_index do |line, y_index|
    line.each_with_index do |value, x_index|
      Octopus.new(value, x_index, y_index)
    end
  end

  counter = 0
  until Octopus.all.reject { |octopus| octopus.energy.zero? }.length.zero?
    counter += 1
    next_step!
    Octopus.all.select(&:flashed?).each(&:reset!)
  end
  puts counter
end

solve_part_1!(test)
solve_part_1!(input)
solve_part_2!(test)
solve_part_2!(input)
